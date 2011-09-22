class InfobaseMovementReport
  
  def self.report(type, region, date, strategies, order)
    rows = []
    result = Activity.includes(:target_area, :team).
      where(TargetArea.table_name + ".region IN (?)", region).
      where(Activity.table_name + ".strategy IN (?)", strategies).
      where(TargetArea.table_name + ".isClosed is null OR " + TargetArea.table_name + ".isClosed = ''").
      where(Activity.table_name + ".status IN (?)", Activity.active_statuses)
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