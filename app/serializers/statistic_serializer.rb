require_dependency 'cru_enhancements'

class StatisticSerializer < ActiveModel::Serializer
  attributes :id, :activity_id, :period_begin, :period_end, :spiritual_conversations, :holy_spirit_presentations,
    :personal_evangelism, :personal_decisions, :group_evangelism, :group_decisions,
    :media_exposures, :media_decisions, :graduating_on_mission, :faculty_on_mission,
    :students_involved, :students_engaged, :student_leaders,
    :faculty_involved, :faculty_engaged, :faculty_leaders, :sp_year, :event_id

  has_one :target_area

  def event_id
    object.target_area.event_id
  end
end
