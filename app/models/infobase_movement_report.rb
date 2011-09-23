class InfobaseMovementReport
  
  def self.report(type, region, date, strategies, order)
    first_query = ActivityHistory.select(ActivityHistory.table_name + ".activity_id").
      select("MAX(" + ActivityHistory.table_name + ".period_begin) as period_begin").
      where(ActivityHistory.table_name + ".period_begin <= ?", date).
      group(ActivityHistory.table_name + ".activity_id")
    second_query = ActivityHistory.select(ActivityHistory.table_name + ".id").
      joins("INNER JOIN (" + first_query.to_sql + " ) last_dates ON " + ActivityHistory.table_name + ".activity_id = last_dates.activity_id AND " + ActivityHistory.table_name + ".period_begin = last_dates.period_begin")
    rows = []
    result = Activity.includes(:target_area, :team, :activity_histories).
      where(ActivityHistory.table_name + ".id IN (?)", second_query.collect(&:id)).
      where(TargetArea.table_name + ".region IN (?)", region).
      where(Activity.table_name + ".strategy IN (?)", strategies).
      where(TargetArea.table_name + ".isClosed is null OR " + TargetArea.table_name + ".isClosed = ''").
      where(ActivityHistory.table_name + ".status IN (?)", Activity.active_statuses)
    order.each_key do |key|
      result = result.order(translate_order(order[key])) if !order[key].blank?
    end
    result.each do |result|
      rows << result
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
end