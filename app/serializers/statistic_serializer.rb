class StatisticSerializer < ActiveModel::Serializer
  attributes :id, :activity_id, :period_begin, :period_end, :spiritual_conversations, :holy_spirit_presentations, 
    :personal_evangelism, :personal_decisions, :group_evangelism, :group_decisions,
    :media_exposures, :media_decisions, :graduating_on_mission, :faculty_on_mission,
    :students_involved, :students_engaged, :student_leaders,
    :faculty_involved, :faculty_engaged, :faculty_leaders
    
  def id; object.StatisticID; end
  def activity_id; object.fk_Activity; end
  def period_begin; object.periodBegin; end
  def period_end; object.periodEnd; end
  #def spiritual_conversations; object.spiritual_conversations; end
  def holy_spirit_presentations; object.holySpiritConversations; end
  def personal_evangelism; object.evangelisticOneOnOne; end
  def personal_decisions; object.decisionsHelpedByOneOnOne; end
  def group_evangelism; object.evangelisticGroup; end
  def group_decisions; object.decisionsHelpedByGroup; end
  def media_exposures; object.exposuresViaMedia; end
  def media_decisions; object.decisionsHelpedByMedia; end
  def graduating_on_mission; object.laborersSent; end
  def faculty_on_mission; object.faculty_sent; end
  def students_involved; object.invldStudents; end
  def students_engaged; object.multipliers; end
  def student_leaders; object.studentLeaders; end
  #def faculty_involved; object.faculty_involved; end
  #def faculty_engaged; object.faculty_engaged; end
  #def faculty_leaders; object.faculty_leaders; end
end
