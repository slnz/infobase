class InfobaseReportRow
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :key, :no_link
  Statistic.event_stats.each do |stat_type|
    attr_accessor stat_type.to_sym
  end
  Statistic.semester_stats.each do |stat_type|
    attr_accessor stat_type.to_sym
  end

  def as_json(options = {})
    {
        :spiritual_conversations => spiritual_conversations,
        :personal_exposures => evangelisticOneOnOne,
        :personal_evangelism => evangelisticOneOnOne,
        :group_exposures => evangelisticGroup,
        :group_evangelism => evangelisticGroup,
        :media_exposures => exposuresViaMedia,
        :holy_spirit_presentations => holySpiritConversations,
        :personal_decisions => decisionsHelpedByOneOnOne,
        :group_decisions => decisionsHelpedByGroup,
        :media_decisions => decisionsHelpedByMedia,
        :graduating_on_mission => laborersSent,
        :faculty_on_mission => faculty_sent,
        :laborers_sent => laborersSent,
        :students_involved => invldStudents,
        :students_engaged => multipliers,
        :student_leaders => studentLeaders,
        :faculty_involved => faculty_involved,
        :faculty_engaged => faculty_engaged,
        :faculty_leaders => faculty_leaders,
    }
  end

  def persisted?
    false
  end

  def initialize(name = "Totals", stats = nil, last_stats = [], key = nil, no_link = false)
    @name = name
    @stats = stats
    @last_stats = last_stats || []
    @key = key
    @no_link = no_link
    set_stats
  end

  def + (row)
    new = self.clone
    Statistic.weekly_stats.each do |stat_type|
      if new.instance_variable_get("@#{stat_type}").present? && row.instance_variable_get("@#{stat_type}").present?
        new.instance_variable_set("@#{stat_type}", new.instance_variable_get("@#{stat_type}") + row.instance_variable_get("@#{stat_type}"))
      elsif new.instance_variable_get("@#{stat_type}").present?
        new.instance_variable_set("@#{stat_type}", new.instance_variable_get("@#{stat_type}"))
      elsif row.instance_variable_get("@#{stat_type}").present?
        new.instance_variable_set("@#{stat_type}", row.instance_variable_get("@#{stat_type}"))
      end
    end
    new
  end

  private

  def set_stats
    event_stats = Statistic.event_stats
    if !@last_stats.empty?
      event_stats.delete("invldStudents") #invldStudents will be counted in semester stats
    end
    event_stats.each do |stat_type|
      instance_variable_set("@#{stat_type}", 0)
      instance_variable_set("@#{stat_type}", @stats.send(stat_type)) if @stats && @stats.has_attribute?(stat_type) && @stats[stat_type].present?
    end

    Statistic.semester_stats.each do |stat_type|
      instance_variable_set("@#{stat_type}", 0) unless !instance_variable_get("@#{stat_type}").blank?
      @last_stats.each do |stat|
        instance_variable_set("@#{stat_type}", instance_variable_get("@#{stat_type}") + stat.send(stat_type)) if stat.has_attribute?(stat_type) && stat[stat_type].present?
      end
    end
  end
end