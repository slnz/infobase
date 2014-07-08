require 'cru_lib/async'

class Statistic < ActiveRecord::Base
  include Sidekiq::Worker
  include CruLib::Async

  self.table_name = "ministry_statistic"
  self.primary_key = "StatisticID"
  belongs_to :activity, :foreign_key => "fk_Activity"

  validates_numericality_of :spiritual_conversations, :evangelisticOneOnOne, :evangelisticGroup, :exposuresViaMedia,
                            :holySpiritConversations, :decisionsHelpedByOneOnOne, :decisionsHelpedByGroup, :decisionsHelpedByMedia,
                            :laborersSent, :faculty_sent, :multipliers, :studentLeaders, :invldStudents, :faculty_involved,
                            :faculty_engaged, :faculty_leaders, :ongoingEvangReln, :dollars_raised, :only_integer => true, :allow_nil => true

  after_save :change_activity_status
  after_commit :push_to_global_registry
  after_destroy :delete_from_global_registry

  alias_attribute :activity_id, :fk_Activity
  alias_attribute :period_begin, :periodBegin
  alias_attribute :period_end, :periodEnd
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
  alias_attribute :seekers, :ongoingEvangReln

  #Scopes
  def self.before_date(date)
    where(Statistic.table_name + ".periodBegin <= ?", date)
  end

  def self.after_date(date)
    where(Statistic.table_name + ".periodEnd >= ?", date)
  end

  def self.between_dates(from_date, to_date)
    after_date(from_date).before_date(to_date)
  end

  def self.collate_values(from_date, to_date)
    select("SUM(spiritual_conversations) as spiritual_conversations,
            SUM(holySpiritConversations) as holySpiritConversations,
            SUM(evangelisticOneOnOne) as evangelisticOneOnOne,
            SUM(decisionsHelpedByOneOnOne) as decisionsHelpedByOneOnOne,
            SUM(evangelisticGroup) as evangelisticGroup,
            SUM(decisionsHelpedByGroup) as decisionsHelpedByGroup,
            SUM(exposuresViaMedia) as exposuresViaMedia,
            SUM(decisionsHelpedByMedia) as decisionsHelpedByMedia,
            SUM(laborersSent) as laborersSent,
            SUM(faculty_sent) as faculty_sent,
            SUM(invldStudents) as invldStudents,
            SUM(multipliers) as multipliers,
            SUM(studentLeaders) as studentLeaders,
            SUM(faculty_involved) as faculty_involved,
            SUM(faculty_engaged) as faculty_engaged,
            SUM(faculty_leaders) as faculty_leaders,
            fk_Activity,
            '#{from_date.to_s(:db)}' as period_begin,
            '#{to_date.to_s(:db)}' as period_end")
    .between_dates(from_date, to_date)
  end

  #Constants
  def self.weekly_stats # Order matters! Reports rely on correct order, if changed here, change Infobase app/views/reports/_report_header_bar.html.erb
    ["evangelisticOneOnOne", "decisionsHelpedByOneOnOne", "evangelisticGroup", "decisionsHelpedByGroup", "exposuresViaMedia", "decisionsHelpedByMedia", "spiritual_conversations", "holySpiritConversations", "laborersSent", "faculty_sent"]
  end

  def self.semester_stats # Order matters! Reports rely on correct order, if changed here, change Infobase app/views/reports/_report_header_bar.html.erb
    ["invldStudents", "multipliers", "studentLeaders", "faculty_involved", "faculty_engaged", "faculty_leaders"]
  end

  def self.all_stats
    Statistic.weekly_stats + Statistic.semester_stats + ["dollars_raised"]
  end

  def self.event_stats
    Statistic.weekly_stats + ["invldStudents", "dollars_raised"]
  end

  def self.people_groups
    ["(Other Internationals)", "East Asian", "Ishmael Project", "Japanese", "South Asian"]
  end

  def self.uses_seekers
    []
  end

  def period_begin
    self[:period_begin] || periodBegin
  end

  def period_end
    self[:period_end] || periodEnd
  end

  def target_area
    activity.try(:target_area)
  end

  #Instance Methods
  def prefill_semester_stats
    prev_stat = get_previous_stat
    if prev_stat
      Statistic.semester_stats.each do |field|
        self[field] = prev_stat[field]
      end
    end
  end

  def add_stats(new_stat)
    Statistic.event_stats.each do |stat|
      old_stat = self[stat] || 0
      self[stat] = old_stat + new_stat[stat].to_i
      if self[stat] == 0
        self[stat] = nil
      end
    end
  end

  # Don't save if everything is nil
  def save
    attribs = attributes.clone

    # Don't care about these attributes
    attribs.delete("periodBegin")
    attribs.delete("periodEnd")
    attribs.delete("fk_Activity")
    attribs.delete("peopleGroup")
    attribs.delete("updated_by")

    # Need to compare the semester/quarter stats to previous stat record
    prev_stat = get_previous_stat
    changed = false
    if prev_stat
      Statistic.semester_stats.each do |field|
        changed = changed || self[field] != prev_stat[field]
        attribs.delete(field)
      end
    end

    values = attribs.values.compact
    if !values.empty? || changed
      super
    end
  end

  # Will return nil if there isn't a previous stat
  def get_previous_stat
    result = nil
    stats = activity.statistics
    if activity.strategy == "BR"
      stats = stats.where(:peopleGroup => peopleGroup)
    end
    index = stats.index(self)
    if index == nil
      result = stats.last
    elsif index > 0
      result = stats[index - 1]
    end

    result
  end

  def to_ser_hash
    serializer = active_model_serializer
    serializable = serializer.new(self)
    serializable.serializable_hash
  end

  def self.gr_measurement_type_mappings
    {
      exposuresViaMedia: 'Media Exposures',
      evangelisticOneOnOne: 'Personal Evangelism',
      evangelisticGroup: 'Group Evangelism',
      invldStudents: 'Students Involved',
      studentLeaders: 'Student Leaders',
      multipliers: 'Engaged Student Disciples',
      laborersSent: 'Graduating on Mission',
      decisionsHelpedByMedia: 'Media Exposure Decisions',
      decisionsHelpedByOneOnOne: 'Personal Evangelism Decisions',
      decisionsHelpedByGroup: 'Group Evangelism Decisions',
      holySpiritConversations: 'Holy Spirit Presentations',
      spiritual_conversations: 'Spiritual Conversations',
      faculty_sent: 'Faculty on Mission',
      faculty_involved: 'Faculty Involved',
      faculty_engaged: 'Engaged Faculty Disciples',
      faculty_leaders: 'Faculty Leaders'
    }
  end

  def self.gr_related_entity_type_id
    activity_entity_type = Rails.cache.fetch(:activity_entity_type, expires_in: 1.hour) do
      GlobalRegistry::EntityType.get(
        {'filters[name]' => '_relationship'}
      )['entity_types'].first['fields'].detect {
        |f| f['name'] == 'movement'
      }
    end
    activity_entity_type['id']
  end

  def self.gr_category
    'LMI'
  end

  def self.gr_unit
    'people'
  end

  def delete_from_global_registry
    async(:async_push_to_global_registry)
  end

  def async_delete_from_global_registry(registry_id)
    begin
      GlobalRegistry::Entity.delete(registry_id)
    rescue RestClient::ResourceNotFound
      # If the record doesn't exist, we don't care
    end
  end

  # Define default push method
  def push_to_global_registry
    async(:async_push_to_global_registry)
  end

  def async_push_to_global_registry
    return unless activity

    activity.async_push_to_global_registry unless activity.global_registry_id.present?

    return unless activity.global_registry_id.present?

    detailed_mappings = self.class.gr_measurement_types

    measurements = []
    detailed_mappings.each do |column_name, measurement_type|
      total = activity.statistics.where("periodBegin >= ? AND periodBegin <= ?", periodBegin.beginning_of_month, periodBegin.end_of_month)
      .sum(column_name)
      if total > 0
        month = periodBegin.beginning_of_month.strftime("%Y-%m")
        measurements << {
          measurement_type_id: measurement_type['id'],
          related_entity_id: activity.global_registry_id,
          period: month,
          value: total
        }
      end
    end

    GlobalRegistry::Measurement.post(measurements: measurements) if measurements.present?
  end

  def update_in_global_registry
    GlobalRegistry::Entity.put(global_registry_id, {entity: attributes_to_push})
  end

  def create_in_global_registry(parent_id = nil)
    entity = GlobalRegistry::Entity.post(entity: {self.class.global_registry_entity_type_name => attributes_to_push.merge({client_integration_id: id}), parent_id: parent_id})
    entity = entity['entity']
    update_column(:global_registry_id, entity[self.class.global_registry_entity_type_name]['id'])
  end

  def self.gr_measurement_types(measurement_type_mappings = gr_measurement_type_mappings, related_entity_type_id = gr_related_entity_type_id, category = gr_category, unit = gr_unit, description = '', frequency = 'monthly')
    Rails.cache.fetch(:detailed_mappings, expires_in: 1.hour) do
      mappings = {}
      measurement_type_mappings.each do |column_name, type_name|
        gr_type = GlobalRegistry::MeasurementType.get({'filters[name]' => type_name})['measurement_types'].first

        unless gr_type
          gr_type = GlobalRegistry::MeasurementType.post(measurement_type: {
            name: type_name,
            related_entity_type_id: related_entity_type_id,
            category: category,
            unit: unit,
            description: description,
            frequency: frequency
          })
        end

        mappings[column_name] = gr_type
      end
      mappings
    end
  end



  protected

  def change_activity_status
    # Check to make sure this is the last stat record
    if activity.statistics.order(:periodBegin).last == self
      total_involvement = self.students_involved.to_i + self.faculty_involved.to_i
      total_leader_involvement = self.student_leaders.to_i + self.faculty_leaders.to_i
      case
      when total_involvement > Activity::MULITPLYING_INVOLVEMENT_LEVEL && total_leader_involvement > Activity::MULITPLYING_LEADER_INVOLVEMENT_LEVEL
        new_status = "MU"
      when total_leader_involvement > Activity::LAUNCHED_LEADER_INVOLVEMENT_LEVEL
        new_status = "LA"
      when total_leader_involvement >= Activity::KEYLEADER_LEADER_INVOLVEMENT_LEVEL
        new_status = "KE"
      when total_leader_involvement == Activity::PIONEERING_LEADER_INVOLVEMENT_LEVEL
        new_status = "PI"
      else
        new_status = nil
      end
      if new_status != activity.status
        user_id = Thread.current[:user].try(:id)
        activity.update_attributes_add_history({status: new_status, periodBegin: Time.now}, user_id)
      end
    end
  end
end
