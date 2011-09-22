class InfobaseMovementReport
  
  def self.report(type, region, date, strategies, order)
    rows = []
    result = Activity.joins(:target_area, :team).
      where(TargetArea.table_name + ".region IN (?)", region).
      where(Activity.table_name + ".strategy IN (?)", strategies).
      where(TargetArea.table_name + ".isClosed is null OR " + TargetArea.table_name + ".isClosed = ''").
      where(Activity.table_name + ".status IN (?)", Activity.active_statuses)
    result.each do |result|
      rows << result
    end
    rows
  end
end