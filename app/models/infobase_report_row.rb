class InfobaseReportRow
  include ActiveModel::SerializerSupport
  attr_accessor :name, :key, :bridges_rows, :no_link, :personal_exposures, 
    :personal_evangelism, :group_exposures, :group_evangelism, :media_exposures, :holy_spirit_presentations,
    :personal_decisions, :group_decisions, :media_decisions, :graduating_on_mission, :faculty_on_mission,
    :laborers_sent, :students_involved, :students_engaged, :student_leaders
  Statistic.event_stats.each do |stat_type|
    attr_accessor stat_type.to_sym
  end
  Statistic.semester_stats.each do |stat_type|
    attr_accessor stat_type.to_sym
  end
  
  #alias_attribute :spiritual_conversations, :spiritual_conversations
  alias_attribute :personal_exposures, :evangelisticOneOnOne
  alias_attribute :personal_evangelism, :evangelisticOneOnOne
  alias_attribute :group_exposures, :evangelisticGroup
  alias_attribute :group_evangelism, :evangelisticGroup
  alias_attribute :media_exposures, :exposuresViaMedia
  alias_attribute :holy_spirit_presentations, :holySpiritConversations
  alias_attribute :personal_decisions, :decisionsHelpedByOneOnOne
  alias_attribute :group_decisions, :decisionsHelpedByGroup
  alias_attribute :media_decisions, :decisionsHelpedByMedia
  alias_attribute :graduating_on_mission, :laborersSent
  alias_attribute :faculty_on_mission, :faculty_sent
  alias_attribute :laborers_sent, :laborersSent
  alias_attribute :students_involved, :invldStudents
  alias_attribute :students_engaged, :multipliers
  alias_attribute :student_leaders, :studentLeaders
  #alias_attribute :faculty_involved, :faculty_involved
  #alias_attribute :faculty_engaged, :faculty_engaged
  #alias_attribute :facutly_leaders, :facutly_leaders
  alias_attribute :seekers, :ongoingEvangReln

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
    if !@last_stats.empty?
      event_stats.delete("invldStudents") #invldStudents will be counted in semester stats
    end
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