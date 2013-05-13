class InfobaseMovementReport
  
  def self.report(type, region, date, strategies, order)
    # This query finds the latest date for each activity_id that was before the given date
    max_dates_query = ActivityHistory.select(ActivityHistory.table_name + ".activity_id").
      select("MAX(" + ActivityHistory.table_name + ".period_begin) as period_begin").
      where(ActivityHistory.table_name + ".period_begin <= ?", date).
      group(ActivityHistory.table_name + ".activity_id")
    # This query finds the list of activity_history ids that go along with the above query
    history_ids_query = ActivityHistory.select("MAX(" + ActivityHistory.table_name + ".id) AS id").select(ActivityHistory.table_name + ".activity_id").
      joins("INNER JOIN (" + max_dates_query.to_sql + " ) last_dates ON " + ActivityHistory.table_name + ".activity_id = last_dates.activity_id AND " + ActivityHistory.table_name + ".period_begin = last_dates.period_begin").
      group(ActivityHistory.table_name + ".activity_id")
    rows = []
    result = Activity.includes(:target_area, :team, :activity_histories).
      where(ActivityHistory.table_name + ".id IN (?)", history_ids_query.collect(&:id)).
      where(Activity.table_name + ".strategy IN (?)", strategies).
      where(TargetArea.table_name + ".isClosed is null OR " + TargetArea.table_name + ".isClosed = ''").
      where(ActivityHistory.table_name + ".status IN (?)", Activity.active_statuses)
    result = region_clause(result, type, region)
    result = group_clause(result, type)
    order.each_key do |key|
      result = result.order(translate_order(order[key])) if !order[key].blank?
    end
    result.each do |r|
      rows << r
    end
    rows
  end

  def self.translate_order(order, type = "movement")
    result = ""
    case order
    when "campus"
      result = TargetArea.table_name + ".name"
    when "city"
      result = TargetArea.table_name + ".state, " + TargetArea.table_name + ".city"
    when "team"
      result = Team.table_name + ".name"
    when "region"
      result = TargetArea.table_name + ".region"
    when "status"
      result = Activity.table_name + ".status"
    when "ministry"
      result = Activity.table_name + ".strategy"
    end
    result
  end
  
  private
  
  def self.group_clause(query, type)
    result = query
    if type == "location"
      result = result.group(TargetArea.table_name + ".targetAreaID")
    elsif type == "teamorg" || type == "teamgeo"
      result = result.group(Team.table_name + ".teamID")
    end
    result
  end
  
  def self.region_clause(query, type, region)
    result = query
    if type == "teamorg"
      result = result.where(Team.table_name + ".region IN (?)", region)
    else
      result = result.where(TargetArea.table_name + ".region IN (?)", region)
    end
    result
  end
end