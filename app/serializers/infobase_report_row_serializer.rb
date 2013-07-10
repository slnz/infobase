class InfobaseReportRowSerializer < ActiveModel::Serializer
  attributes :spiritual_conversations, :holy_spirit_presentations, 
    :personal_evangelism, :personal_decisions, :group_evangelism, :group_decisions,
    :media_exposures, :media_decisions, :graduating_on_mission, :faculty_on_mission,
    :students_involved, :students_engaged, :student_leaders,
    :faculty_involved, :faculty_engaged, :faculty_leaders
end
