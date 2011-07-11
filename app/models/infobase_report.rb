class InfobaseReport
  attr_accessor :rows
  
  def initialize(rows)
    @rows = rows
  end
  
  def get_totals
    unless @totals
      @totals = InfobaseReportRow.new
      Statistic.weekly_stats.each do |stat_type|
        total = 0
        @rows.each do |row|
          total += row.send(stat_type) if row.send(stat_type)
        end
        @totals.send(stat_type + "=", total)
      end
      Statistic.semester_stats.each do |stat_type|
        total = 0
        @rows.each do |row|
          total += row.send(stat_type) if row.send(stat_type)
        end
        @totals.send(stat_type + "=", total)
      end
    end
    @totals
  end
  
  def self.create_national_report(from_date, to_date, strategies)
    rows = []
    Region.standard_region_codes.each do |region|
      stats = Statistic.where(Statistic.table_name + ".periodBegin > ?", from_date).where(Statistic.table_name + ".periodEnd < ?", to_date).
        joins(:activity => :target_area).where(Activity.table_name + ".strategy IN (?)", strategies).
        where(TargetArea.table_name + ".region = ?", region).
        group(TargetArea.table_name + ".region")
        Statistic.weekly_stats.each do |stat|
          stats = stats.select("SUM(#{stat}) AS #{stat}")
        end
      last_stats = Statistic.where(Statistic.table_name + ".periodBegin > ?", from_date).where(Statistic.table_name + ".periodEnd < ?", to_date).
        joins(:activity => :target_area).where(Activity.table_name + ".strategy IN (?)", strategies).
        where(TargetArea.table_name + ".region = ?", region).
        group(Statistic.table_name + ".fk_Activity").having("max(" + Statistic.table_name + ".periodEnd)")
        Statistic.semester_stats.each do |stat|
          last_stats = last_stats.select("SUM(#{stat}) AS #{stat}")
        end
      rows << InfobaseReportRow.new(Region.full_name(region), stats.first, last_stats, region)
    end
    InfobaseReport.new(rows)
  end

  def self.create_regional_report(region, from_date, to_date, strategies)
    rows = []
    teams = Team.active.where("region = ?", region).order(:name)
    teams.each do |team|
      stats = Statistic.where(Statistic.table_name + ".periodBegin > ?", from_date).where(Statistic.table_name + ".periodEnd < ?", to_date).
        joins(:activity => :target_area).where(Activity.table_name + ".strategy IN (?)", strategies).
        where(TargetArea.table_name + ".region = ?", region).
        where(Activity.table_name + ".fk_teamID = ?", team.id).
        group(TargetArea.table_name + ".region")
        Statistic.weekly_stats.each do |stat|
          stats = stats.select("SUM(#{stat}) AS #{stat}")
        end
      last_stats = Statistic.where(Statistic.table_name + ".periodBegin > ?", from_date).where(Statistic.table_name + ".periodEnd < ?", to_date).
        joins(:activity => :target_area).where(Activity.table_name + ".strategy IN (?)", strategies).
        where(TargetArea.table_name + ".region = ?", region).
        where(Activity.table_name + ".fk_teamID = ?", team.id).
        group(Statistic.table_name + ".fk_Activity").having("max(" + Statistic.table_name + ".periodEnd)")
        Statistic.semester_stats.each do |stat|
          last_stats = last_stats.select("SUM(#{stat}) AS #{stat}")
        end
      rows << InfobaseReportRow.new(team.name, stats.first, last_stats, team.id)
    end
    InfobaseReport.new(rows)
  end
end