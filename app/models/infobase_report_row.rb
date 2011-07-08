class InfobaseReportRow
  attr_accessor :name
  Statistic.weekly_stats.each do |stat_type|
    attr_accessor stat_type.to_sym
  end
  Statistic.semester_stats.each do |stat_type|
    attr_accessor stat_type.to_sym
  end
  
  def initialize(name = "Totals", stats = [], last_stats = [])
    @name = name
    @stats = stats
    @last_stats = last_stats
    add_stats
  end
  
  private
  
  def add_stats
    Statistic.weekly_stats.each do |stat_type|
      instance_variable_set("@#{stat_type}", 0)
      @stats.each do |stat|
        instance_variable_set("@#{stat_type}", instance_variable_get("@#{stat_type}") + stat.send(stat_type)) if stat.send(stat_type)
      end
    end
    
    Statistic.semester_stats.each do |stat_type|
      instance_variable_set("@#{stat_type}", 0)
      @last_stats.each do |stat|
        instance_variable_set("@#{stat_type}", instance_variable_get("@#{stat_type}") + stat.send(stat_type)) if stat.send(stat_type)
      end
    end
  end
end