class InfobaseReport
  attr_accessor :rows, :row_type
  
  def initialize(rows, row_type)
    @rows = rows
    @row_type = row_type
  end
  
  def self.reports_to_add_semester_stats
    ["Region", "Team", "Ministry Location"]
  end
  
  def get_totals
    unless @totals
      @totals = InfobaseReportRow.new
      Statistic.all_stats.each do |stat_type|
        total = 0
        @rows.each do |row|
          total += row.send(stat_type) if row.send(stat_type)
        end
        @totals.send(stat_type + "=", total)
      end

      # When displaying weekly stats records for a single activity we just want to grab the most recent stats
      if !InfobaseReport.reports_to_add_semester_stats.include?(@row_type)
        Statistic.semester_stats.each do |stat_type|
          total = 0
          last_row = @rows.last
          total = last_row.send(stat_type) if last_row && last_row.send(stat_type)
          @totals.send(stat_type + "=", total)
        end
      end
    end
    @totals
  end
  
  def self.create_report(from_date, to_date, semester_date, activity_ids)
    stats = start_stats_query(from_date, to_date)
    stats = add_activities_clause(stats, activity_ids)
    stats = sum_weekly_stats(stats)
    
    first_sem_date = semester_date - 1.year
    last_end_date_ids = get_last_end_date_ids(first_sem_date, semester_date)
    last_stats = start_stats_query(first_sem_date, semester_date)
    last_stats = add_activities_clause(last_stats, activity_ids).
      where(Statistic.table_name + ".statisticID IN (?)", last_end_date_ids.collect(&:statisticID))
    last_stats = sum_semester_stats(last_stats)
    
    InfobaseReport.new([InfobaseReportRow.new("stats", stats.first, last_stats)], "stats")
  end
  
  def self.create_national_report(from_date, to_date, strategies, type)
    rows = []
    regions = Region.standard_region_codes
    regions << "nil" if type != "campus"
    regions.uniq!
    Region.standard_region_codes.each do |region|
      stats = start_national_query(from_date, to_date, strategies, region, type)
      
      if type == "campus"
        stats = sum_weekly_stats(stats)

        last_end_date_ids = get_last_end_date_ids(from_date, to_date)
        last_stats = start_national_query(from_date, to_date, strategies, region, type).
          where(Statistic.table_name + ".statisticID IN (?)", last_end_date_ids.collect(&:statisticID))
        last_stats = sum_semester_stats(last_stats)
      else
        stats = sum_event_stats(stats)
      end
      
      rows << InfobaseReportRow.new(Region.full_name(region), stats.first, last_stats, region)
    end
    InfobaseReport.new(rows, "Region")
  end

  def self.create_regional_report(region, from_date, to_date, strategies)
    rows = []
    teams = Team.where("region = ? OR hasMultiRegionalAccess = 'T'", region).includes(:activities => :target_area).order(:name)
    teams.each do |team|
      stats = start_regional_query(from_date, to_date, strategies, region, team).
        group(Activity.table_name + ".fk_teamID")
      stats = sum_weekly_stats(stats)
      
      last_end_date_ids = get_last_end_date_ids(from_date, to_date)
      last_stats = start_regional_query(from_date, to_date, strategies, region, team).
        where(Statistic.table_name + ".statisticID IN (?)", last_end_date_ids.collect(&:statisticID))
      last_stats = sum_semester_stats(last_stats)
      
      if (team.is_active? && team.is_responsible_for_strategies_in_region?(strategies, region)) || !stats.empty?
        row_header = team.name.to_s
        row_header += "<font color='red'> - Inactive Team</font>" unless team.is_active?
        rows << InfobaseReportRow.new(row_header.html_safe, stats.first, last_stats, team.id)
      end
    end
    InfobaseReport.new(rows, "Team")
  end
  
  def self.create_team_report(team, from_date, to_date, strategies, type, region = nil)
    rows = []
    if type == "campus"
      activities = team.get_activities_for_strategies(strategies)
    else
      activities = get_event_activities(type, region)
    end

    activities.each do |activity|
      stats = start_team_query(from_date, to_date, strategies, activity, type).
        group(Activity.table_name + ".ActivityId")
      
      if type == "campus"
        stats = sum_weekly_stats(stats)
        
        max_end_date = activity.statistics.between_dates(from_date, to_date).maximum(Statistic.table_name + ".periodEnd")
        last_stats = start_team_query(from_date, to_date, strategies, activity, type).
          where(Statistic.table_name + ".periodEnd = ?", max_end_date)
        last_stats = sum_semester_stats(last_stats)
      else
        stats = sum_event_stats(stats)
      end
      
      if activity.is_active? || !stats.empty?
        row_header = activity.target_area.name.to_s 
        row_header += "<br/>(" + activity.target_area.enrollment.to_s + " enrolled)" if !activity.target_area.enrollment.blank?
        row_header += "<br/><i>" + Activity.strategies[activity.strategy].to_s + "</i>"
        row_header += "<br/><font color='red'>Inactive Movement</font>" if type == "campus" && !activity.is_active?
        rows << InfobaseReportRow.new(row_header.html_safe, stats.first, last_stats, activity.target_area.id)
      end
    end
    InfobaseReport.new(rows, "Ministry Location")
  end
  
  def self.create_location_reports(location, from_date, to_date, strategies, type, team = nil)
    reports = []
    activities = location.get_activities_for_strategies(strategies)
    activities.each do |activity|
      rows = []
      stats = activity.statistics.between_dates(from_date, to_date).
        group(Statistic.table_name + ".periodBegin").
        select(Statistic.table_name + ".periodBegin").
        select(Statistic.table_name + ".periodEnd").
        select(Statistic.table_name + ".statisticID")
      
      if type == "campus"
        stats = sum_all_stats(stats)
      else
        stats = sum_event_stats(stats)
      end
      
      stats.each do |stat|
        rows << InfobaseReportRow.new(stat.periodBegin.to_s + " - " + stat.periodEnd.to_s, stat, [stat], stat.statisticID.to_s, true)
      end

      if activity.is_active? || !rows.empty?
        report_header = activity.target_area.name.to_s + " - <br/>" + Activity.strategies[activity.strategy].to_s
        report_header += "<br/><font color='red'>Inactive Movement</font>" if type == "campus" && !activity.is_active?
        if team && activity.team != team
          report_header += "<br/><font color='red'>(Belongs to another Team: #{activity.team.name})</font>"
        end
        reports << InfobaseReport.new(rows, report_header)
      end
    end
    reports
  end
  
  private
  
  def self.sum_weekly_stats(stats)
    Statistic.weekly_stats.each do |stat|
      stats = stats.select("SUM(#{stat}) AS #{stat}")
    end
    stats
  end
  
  def self.sum_semester_stats(stats)
    Statistic.semester_stats.each do |stat|
      stats = stats.select("SUM(#{stat}) AS #{stat}")
    end
    stats
  end
  
  def self.sum_event_stats(stats)
    Statistic.event_stats.each do |stat|
      stats = stats.select("SUM(#{stat}) AS #{stat}")
    end
    stats
  end

  def self.sum_all_stats(stats)
    stats = sum_weekly_stats(stats)
    stats = sum_semester_stats(stats)
    stats
  end
  
  def self.start_national_query(from_date, to_date, strategies, region, type)
    stats = start_stats_query(from_date, to_date)
    stats = add_strategies_clause(stats, strategies)
    stats = add_region_clause(stats, region)
    stats = add_type_clause(stats, type)
    stats = add_joins(stats)
    stats
  end
  
  def self.start_regional_query(from_date, to_date, strategies, region, team)
    stats = start_national_query(from_date, to_date, strategies, region, "campus")
    stats = add_team_clause(stats, team)
    stats
  end
  
  def self.start_team_query(from_date, to_date, strategies, activity, type)
    stats = start_stats_query(from_date, to_date)
    stats = add_strategies_clause(stats, strategies)
    stats = add_activity_clause(stats, activity)
    stats = add_type_clause(stats, type)
    stats = add_joins(stats)
    stats
  end
  
  def self.get_event_activities(type, region)
    relation = Activity
    relation = add_type_clause(relation, type)
    relation = add_region_clause(relation, region)
    relation = relation.joins(:target_area)
    relation
  end
  
  def self.start_stats_query(from_date, to_date)
    Statistic.between_dates(from_date, to_date)
  end
  
  def self.add_joins(relation)
    relation.joins(:activity => :target_area)
  end
  
  def self.add_strategies_clause(relation, strategies)
    relation.where(Activity.table_name + ".strategy IN (?)", strategies)
  end
  
  def self.add_region_clause(relation, region)
    if region == "nil"
      relation.where(TargetArea.table_name + ".region is null OR " + TargetArea.table_name + ".region = ''")
    else
      relation.where(TargetArea.table_name + ".region = ?", region)
    end
  end
  
  def self.add_team_clause(relation, team)
    relation.where(Activity.table_name + ".fk_teamID = ?", team.id)
  end
  
  def self.add_activity_clause(relation, activity)
    relation.where(Activity.table_name + ".ActivityId = ?", activity.id)
  end
  
  def self.add_activities_clause(relation, activity_ids)
    relation.where(Statistic.table_name + ".fk_Activity IN (?)", activity_ids)
  end
  
  def self.add_group_clause(relation, group)
    relation.where(Statistic.table_name + ".peopleGroup = ?", group)
  end
  
  def self.add_type_clause(relation, type)
    case type
    when "campus"
      relation.where(TargetArea.table_name + ".type = 'College' OR " + TargetArea.table_name + ".type = 'HighSchool' OR " + TargetArea.table_name + ".type = 'Business'")
    when "SP"
      relation.where(TargetArea.table_name + ".type = 'Event'").where(TargetArea.table_name + ".eventType = 'SP'")
    when "conference"
      relation.where(TargetArea.table_name + ".type = 'Event'").where(TargetArea.table_name + ".eventType = 'C2' OR " + TargetArea.table_name + ".eventType = 'CS'")
    end
  end
  
  def self.get_last_end_date_ids(from_date, to_date)
    # This query finds the latest date for each statistic that was before the given date
    max_dates_query = Statistic.between_dates(from_date, to_date).
      select(Statistic.table_name + ".fk_Activity").
      select("MAX(" + Statistic.table_name + ".periodEnd) as periodEnd").
      group(Statistic.table_name + ".fk_Activity")
    # This query finds the list of statistic ids that go along with the above query
    stats_ids_query = Statistic.select(Statistic.table_name + ".statisticID").
      joins("INNER JOIN (" + max_dates_query.to_sql + " ) last_dates ON " + Statistic.table_name + ".fk_activity = last_dates.fk_activity AND " + Statistic.table_name + ".periodEnd = last_dates.periodEnd")
    stats_ids_query
  end
end