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
          total += row.send(stat_type)
        end
        @totals.send(stat_type + "=", total)
      end
      Statistic.semester_stats.each do |stat_type|
        total = 0
        @rows.each do |row|
          total += row.send(stat_type)
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
        includes(:activity => :target_area).where(Activity.table_name + ".strategy IN (?)", strategies).
        where(TargetArea.table_name + ".region = ?", region)
      last_stats = Statistic.where(Statistic.table_name + ".periodBegin > ?", from_date).where(Statistic.table_name + ".periodEnd < ?", to_date).
        includes(:activity => :target_area).where(Activity.table_name + ".strategy IN (?)", strategies).
        where(TargetArea.table_name + ".region = ?", region).
        group(Statistic.table_name + ".fk_Activity").having("max(" + Statistic.table_name + ".periodEnd)")
      rows << InfobaseReportRow.new(Region.full_name(region), stats, last_stats)
    end
    InfobaseReport.new(rows)
  end
end