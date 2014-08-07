require 'cru_lib/global_registry_relationship_methods'
class Activity < ActiveRecord::Base
  include Sidekiq::Worker
  include CruLib::GlobalRegistryRelationshipMethods

  self.table_name = "ministry_activity"
  self.primary_key = "ActivityID"

  belongs_to :target_area, :foreign_key => "fk_targetAreaID", :primary_key => "targetAreaID"
  belongs_to :team, :foreign_key => "fk_teamID", :primary_key => "teamID"
  has_many :activity_histories
  has_many :statistics, -> { order :periodBegin }, :foreign_key => "fk_Activity"
  has_many :last_fifteen_stats, -> { where("periodBegin > '#{(Date.today - 15.weeks).to_s(:db)}'").order(:periodBegin) }, :class_name => "Statistic", :foreign_key => "fk_Activity"
  has_and_belongs_to_many :contacts, :join_table => "ministry_movement_contact",  :foreign_key => "ActivityID", :association_foreign_key => "personID", :class_name => "Person"

  validates_presence_of :status, :strategy, :periodBegin, :fk_targetAreaID, :fk_teamID

  scope :inactive, -> { where("status = 'IN'") }
  scope :active, -> { where("status NOT IN ('IN', 'TN')") }
  scope :strategy, lambda {|strategy| where("strategy = ?", strategy)}

  alias_attribute :period_begin, :periodBegin
  alias_attribute :period_end, :periodEnd
  alias_attribute :target_area_id, :fk_targetAreaID
  alias_attribute :team_id, :fk_teamID

  before_save :ensure_url_http

  MULITPLYING_INVOLVEMENT_LEVEL = 50
  MULTIPLYING_ENGAGED_DISCIPLE_LEVEL = 5
  MULITPLYING_LEADER_INVOLVEMENT_LEVEL = 1
  LAUNCHED_ENGAGED_DISCIPLE_LEVEL = 5
  LAUNCHED_LEADER_INVOLVEMENT_LEVEL = 1
  KEYLEADER_LEADER_INVOLVEMENT_LEVEL = 1
  PIONEERING_LEADER_INVOLVEMENT_LEVEL = 0

  def self.strategies
    Hash[Strategy.where(city: false).collect { |s| [s.abreviation, s.name] }]
  end

  def self.all_strategies
    Hash[Strategy.all.collect { |s| [s.abreviation, s.name] }]
  end

  def self.bridges
    "BR"
  end

  def self.strategies_translations
    {
      "FS" => "CFM",
      "IE" => "EPI",
      "ID" => "DES",
      "II" => "IMP",
      "IN" => "NTN",
      "WS" => "WSN",
      "BR" => "BRD",
      "AA" => "AIA",
      "FC" => "FC",
      "KC" => "KN",
      "GK" => "GK",
      "VL" => "VL",
      "SA" => "SA",
      "SV" => "SV",
      "EV" => "EV",
      "OT" => "OT",
    }
  end

  def self.event_strategies
    Hash[Strategy.where(event: true).collect { |s| [s.abreviation, s.name] }]
  end

  def self.visible_strategies
    result = event_strategies.clone
    result.delete("EV")
    result
  end

  def self.visible_team_strategies
    result = strategies.clone
    result.delete("EV")
    result
  end

  def self.city_strategies
    Hash[Strategy.where(city: true).collect { |s| [s.abreviation, s.name] }]
  end

  def self.crs_strategies
    {
      "USCM" => "EV",
      "Bridges" => "BR",
      "CCCI" => "OT",
      "StudentVenture" => "SV",
      "Other" => "OT"
    }
  end

  def self.statuses
    {
      "IN" => "Inactive",
      "FR" => "Pioneering",
      "PI" => "Pioneering",
      "KE" => "Key Leader",
      "LA" => "Launched",
      "AC" => "Launched",
      "TR" => "Multiplying",
      "MU" => "Multiplying",
      "TN" => "Transitioned"
    }
  end

  def self.visible_statuses
    result = wsn_statuses.clone
    result.delete("TN")
    result
  end

  def self.wsn_statuses
    result = statuses.clone
    result.delete("FR")
    result.delete("AC")
    result.delete("TR")
    result
  end

  def self.active_statuses
    ["LA", "AC", "TR", "MU"]
  end

  def self.determine_open_strategies(target_area)
    current_activities = target_area.activities
    open_strategies = visible_strategies.keys
    current_activities.each do |activity|
      open_strategies.delete(activity.strategy)
    end
    open_strategies
  end

  def self.translate_strategies_to_PS(strategies)
    result = []
    strategies.each do |strategy|
      result << strategies_translations[strategy]
    end
    result
  end

  def self.new_movement_for_strategy(target_area, strategy)
    activity = strategy(strategy).where("fk_targetAreaID = ?", target_area.targetAreaID).first
    unless activity
      activity = Activity.new(:strategy => strategy)
      activity.target_area = target_area
    end
    activity
  end

  def self.movement_for_event(target_area, period_begin, strategy = "EV")
    activity = Activity.where("fk_targetAreaID = ?", target_area.targetAreaID).first
    unless activity
      activity = Activity.create_movement_for_event(target_area, period_begin, strategy)
    end
    activity.strategy = strategy
    activity.save
    activity
  end

  def self.create_movement_for_event(target_area, period_begin, strategy = "EV")
    activity = Activity.new(:strategy => strategy, :periodBegin => period_begin, :fk_teamID => 0)
    activity.status = "IN"
    activity.target_area = target_area
    activity.save!
    activity
  end

  def self.interpret_strategy_from_crs(strategy)
    crs_strategies[strategy]
  end

  def is_active?
    !['IN', 'TN'].include?(status)
  end

  def is_bridges?
    ['BR'].include?(strategy)
  end

  def name
    target_area.name.to_s + " - " + Activity.strategies[strategy].to_s
  end

  # If status changes, create an ActivityHistory record
  def update_attributes_add_history(attributes, user)
    new_status = attributes[:status]
    if new_status && new_status != status
      begin_date = attributes[:periodBegin]
      begin_date = convert_date(attributes, :periodBegin) if begin_date.class != Time
      ActivityHistory.create(:activity => self, :status => new_status, :period_begin => begin_date, :trans_username => user)
    end
    attributes[:transUsername] = user
    update_attributes(attributes)
  end

  def save_create_history(user, validate = true)
    ActivityHistory.create(:activity => self, :status => status, :period_begin => periodBegin, :trans_username => user.userID)
    transUsername = user.userID
    save(validate: validate)
  end

  def get_stat_for(date, people_group = nil)
    stat = nil
    sunday = date.beginning_of_week(:sunday)
    stat_rel = statistics.where("periodBegin = ?", sunday)
    stat_rel = stat_rel.where("peopleGroup = ?", people_group) if !people_group.blank?
    stat = stat_rel.first
    unless stat
      stat = Statistic.new
      stat.activity = self
      stat.periodBegin = sunday
      stat.periodEnd = sunday.end_of_week(:sunday)
      stat.prefill_semester_stats
    end
    stat
  end

  def get_stats_for_dates(begin_date, end_date, people_group = nil)
    stats = nil
    start_date = begin_date.beginning_of_week(:sunday)
    ending_date = end_date.end_of_week(:sunday)
    stat_rel = statistics.where("periodBegin >= ? AND periodEnd <= ?", start_date, ending_date)
    stats = stat_rel.load
    stats
  end

  def get_sp_stat_for(year, period_begin, period_end, people_group = nil)
    stat = nil
    stat_rel = statistics.where("sp_year = ?", year)
    stat_rel = stat_rel.where("peopleGroup = ?", people_group) if !people_group.blank?
    stat = stat_rel.first
    unless stat
      stat = Statistic.new
      stat.activity = self
    end
    stat.periodBegin = period_begin
    stat.periodEnd = period_end
    stat.sp_year = year
    stat
  end

  def get_crs_stat_for(period_begin, period_end, people_group = nil) # TODO: people groups
    if statistics.size > 1
      raise "Too many stats for this Conference"
    else
      stat = statistics.first
      unless stat
        stat = Statistic.new
        stat.activity = self
      end
      stat.periodBegin = period_begin
      stat.periodEnd = period_end
    end
    stat
  end

  def get_event_stat_for(period_begin, period_end, people_group = nil) # TODO: people groups
    stat = nil
    if target_area.eventType == TargetArea.other_conference
      stat = get_crs_stat_for(period_begin, period_end, people_group)
    else
      stat = statistics.where("periodEnd = ?", period_end).first
    end
    unless stat
      stat = Statistic.new
      stat.activity = self
    end
    stat.periodBegin = period_begin
    stat.periodEnd = period_end
    stat
  end

  def get_activity_history_for_date(date)
    # Find correct date
    max_date = activity_histories.where("period_begin <= ?", date).maximum(:period_begin)
    result = activity_histories.where("period_begin = ?", max_date).first
  end

  def add_bookmark_for(user)
    Bookmark.add_activity_bookmark_for(user, self)
  end

  def get_bookmark_for(user)
    Bookmark.get_activity_bookmark_for(user, self)
  end

  def check_for_activity_since(date)
    !statistics.where("periodEnd > ?", date).empty?
  end

  def async_push_to_global_registry
    return unless target_area && team

    target_area.async_push_to_global_registry unless target_area.global_registry_id.present?
    team.async_push_to_global_registry unless team.global_registry_id.present?
    super
  end

  def attributes_to_push(*args)
    if global_registry_id
      super
    else
      super(relationship_name: 'activity', related_name: 'target_area', related_object: target_area, base_object: team)
    end
  end

  def create_in_global_registry(*args)
    super(team, 'activity')
  end

  def self.push_structure_to_global_registry
    super(Team, TargetArea, 'activity', 'activity')
  end

  def self.skip_fields_for_gr
    super + %w(activity_id period_end_deprecated trans_username fk_target_area_id fk_team_id status_history_deprecated url facebook sent_team_id gcx_site)
  end

  def self.inactivate_activites_without_recent_stats
    user = User.where(username: "Patty.McCain@cru.org").first
    cutoff_date = 1.year.ago

    Activity.active.where("created_at < ? or created_at is null", cutoff_date).where("strategy <> 'SV'").each do |activity| # In 2014, Cru HS opted out
      unless activity.check_for_activity_since(cutoff_date)
        activity.status = "IN"
        activity.transUsername = user.userID
        activity.periodBegin = Date.today
        activity.save_create_history(user, validate: false)
      end
    end
  end

  private

  def convert_date(hash, date_symbol_or_string)
    attribute = date_symbol_or_string.to_s
    return Date.new(hash[attribute + '(1i)'].to_i, hash[attribute + '(2i)'].to_i, hash[attribute + '(3i)'].to_i)
  end

  def ensure_url_http
    if url.present? && !url.starts_with?("http://") && !url.starts_with?("https://")
      self.url = "http://#{url}"
    end
  end
end
