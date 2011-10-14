class InfobaseReportRow
  attr_accessor :name, :key, :bridges_rows, :no_link
  Statistic.event_stats.each do |stat_type|
    attr_accessor stat_type.to_sym
  end
  Statistic.semester_stats.each do |stat_type|
    attr_accessor stat_type.to_sym
  end
  
  def initialize(name = "Totals", stats = nil, last_stats = [], key = nil, bridges_rows = nil, no_link = false)
    @name = name
    @stats = stats
    @last_stats = last_stats || []
    @key = key
    @bridges_rows = bridges_rows
    @no_link = no_link
    set_stats
  end
  
  def is_bridges?
    !@bridges_rows.blank?
  end
  
  private
  
  def set_stats
    event_stats = Statistic.event_stats
    event_stats.delete("invldStudents") #invldStudents will be counted in semester stats
    event_stats.each do |stat_type|
      instance_variable_set("@#{stat_type}", 0)
      instance_variable_set("@#{stat_type}", @stats.send(stat_type)) if @stats && @stats[stat_type]
    end

    Statistic.semester_stats.each do |stat_type|
      instance_variable_set("@#{stat_type}", 0) unless !instance_variable_get("@#{stat_type}").blank?
      @last_stats.each do |stat|
        instance_variable_set("@#{stat_type}", instance_variable_get("@#{stat_type}") + stat.send(stat_type)) if stat[stat_type]
      end
    end
  end
end