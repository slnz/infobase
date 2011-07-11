class InfobaseReportRow
  attr_accessor :name
  attr_accessor :key
  Statistic.weekly_stats.each do |stat_type|
    attr_accessor stat_type.to_sym
  end
  Statistic.semester_stats.each do |stat_type|
    attr_accessor stat_type.to_sym
  end
  
  def initialize(name = "Totals", stats = nil, last_stats = [], key = nil)
    @name = name
    @stats = stats
    @last_stats = last_stats
    @key = key
    set_stats
  end
  
  private
  
  def set_stats
    Statistic.weekly_stats.each do |stat_type|
      instance_variable_set("@#{stat_type}", 0)
      instance_variable_set("@#{stat_type}", @stats.send(stat_type)) if @stats && @stats.send(stat_type)
    end
    
    Statistic.semester_stats.each do |stat_type|
      instance_variable_set("@#{stat_type}", 0)
      @last_stats.each do |stat|
        instance_variable_set("@#{stat_type}", instance_variable_get("@#{stat_type}") + stat.send(stat_type)) if stat.send(stat_type)
      end
    end
  end
end