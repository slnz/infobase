require 'cru_lib/global_registry_methods'
require 'auto_strip_attributes'

class Person < ActiveRecord::Base
  include Sidekiq::Worker
  include CruLib::GlobalRegistryMethods

  auto_strip_attributes :firstName, :lastName, :preferredName, :accountNo, :title

  self.table_name = "ministry_person"
  self.primary_key = "personID"

  belongs_to              :user, :foreign_key => "fk_ssmUserId"  #Link it to SSM

  has_one                 :staff
  has_one                 :spouse, :foreign_key => "fk_spouseID", class_name: 'Person'
  has_many                :team_members, :foreign_key => "personID", dependent: :destroy
  has_many                :teams, :through => :team_members
  has_and_belongs_to_many :activities, -> { order(TargetArea.table_name + ".name").includes(:target_area) }, :join_table => "ministry_movement_contact", :association_foreign_key => "ActivityID", :foreign_key => "personID"

  # Addresses
  has_many                :email_addresses, :foreign_key => "person_id", :class_name => '::EmailAddress', dependent: :destroy
  has_many                :phone_numbers, :foreign_key => "person_id", :class_name => '::PhoneNumber', dependent: :destroy
  has_one                 :current_address, -> { where("addressType = 'current'") }, :foreign_key => "fk_PersonID", :class_name => '::Address'
  has_one                 :permanent_address, -> { where("addressType = 'permanent'") }, :foreign_key => "fk_PersonID", :class_name => '::Address'
  has_one                 :emergency_address1, -> { where("addressType = 'emergency1'") }, :foreign_key => "fk_PersonID", :class_name => '::Address'
  has_many                :addresses, :foreign_key => "fk_PersonID", dependent: :destroy

  # General
  attr_accessor           :school

  validates_uniqueness_of :fk_ssmUserId, :message => "This username already has a person record.", :allow_nil => true
  validates_presence_of :first_name

  accepts_nested_attributes_for :current_address

  before_save :check_region, :stamp_changed
  before_create :stamp_created

  scope :not_secure, -> { where("isSecure != 'T' or isSecure IS NULL") } # NOT secure
  scope :public, -> { where("isSecure NOT IN('T', 'I') or isSecure IS NULL") } # NOT Secure or Semi-Secure

  alias_attribute :account_no, :accountNo
  alias_attribute :preferred_name, :preferredName
  alias_attribute :university_state, :universityState
  alias_attribute :year_in_school, :yearInSchool
  alias_attribute :is_child, :isChild
  alias_attribute :changed_by, :changedBy
  alias_attribute :user_id, :fk_ssmUserId

  def emergency_address
    emergency_address1
  end
  def emergency_address=(address)
    self.emergency_address1 = address
  end

  def create_emergency_address
    Address.create(:fk_PersonID => self.id, :addressType => 'emergency1')
  end

  def create_current_address
    Address.create(:fk_PersonID => self.id, :addressType => 'current')
  end

  def create_permanent_address
    Address.create(:fk_PersonID => self.id, :addressType => 'permanent')
  end

  def region(try_target_area = true)
    region = self[:region]
    region ||= self.target_area.try(:region) if try_target_area
    region
  end

  def target_area
    if (self.school)
      self.school
    else
      if (campus? && universityState?)
        self.school = TargetArea.where(["name = ? AND state = ?", campus, universityState]).first
      elsif (campus?)
        self.school = TargetArea.where(["name = ?", campus]).first
      else
        self.school = nil
      end
    end
  end

  def validate_blogfeed
    errors.add(:blogfeed, "is invalid") if invalid_feed?
  end

  # empty_feed? checks to see if blogfeed has any characters that could be a feed
  def empty_feed?
    blogfeed ? blogfeed.strip.empty? : true
  end

  def invalid_feed?
    FeedTools::Feed.open(blogfeed) unless empty_feed?
  rescue FeedTools::FeedAccessError
    flash[:notice] = "Invalid feed" if @my_entry
  rescue
    flash[:notice] = "Not well formed XML" if @my_entry and not empty_feed?
  end

  def human_gender
    return '' if gender.to_s.empty?
    return is_male? ? 'Male' : 'Female'
  end

  def is_male?
    return gender.to_i == 1
  end

  def is_female?
    return gender.to_i == 0
  end

  def is_high_school?
    return lastAttended == "HighSchool"
  end

  # "first_name last_name"
  def full_name
    first_name.to_s  + " " + last_name.to_s
  end

  # "nickname last_name"
  def informal_full_name
    nickname.to_s  + " " + last_name.to_s
  end

  def name_with_nick
    name = firstName.to_s
    if preferredName.present? && preferredName.strip != firstName.strip
      name += " (#{preferredName.strip}) "
    end
    name + ' ' + lastName.to_s
  end

  # "first_name middle_name last_name"
  def long_name
    l = first_name.to_s + " "
    l += middle_name.to_s + " " if middle_name
    l + last_name.to_s
  end

  # an alias for firstName using standard ruby/rails conventions
  def first_name
    firstName
  end

  def first_name=(f)
    write_attribute("firstName", f)
  end

  # an alias for middleName using standard ruby/rails conventions
  def middle_name
    middleName
  end

  def middle_name=(m)
    write_attribute("middleName", m)
  end

  # an alias for lastName using standard ruby/rails conventions
  def last_name
    lastName
  end

  def last_name=(l)
    write_attribute("lastName", l)
  end

  #a little more than an alias.  Nickname is the preferredName if one is listed.  Otherwise it is first name
  def nickname
    (preferredName and not preferredName.strip.empty?) ? preferredName : firstName
  end

  #nickname is an alias for preferredName
  def nickname=(name)
    write_attribute("preferredName", name)
  end

  # an alias for yearInSchool
  def year
    yearInSchool
  end

  def year=(y)
    write_attribute("yearInSchool", y)
  end

  def marital_status
    Person::MARITAL_STATUSES[maritalStatus]
  end

  MARITAL_STATUSES = {'S' => 'Single',
                      'M' => 'Married',
                      'D' => 'Divorced',
                      'W' => 'Widowed',
                      'P' => 'Separated'}

  #set dateChanged and changedBy
  def stamp_changed
    self.dateChanged = Time.now
    self.changedBy = ApplicationController.application_name
  end
  def stamp() stamp_changed end # backwards compatibility
  def stamp_created
    self.dateCreated = Time.now
    self.createdBy = ApplicationController.application_name
  end

  # include FileColumnHelper

  # file_column picture
  def pic(size = "mini")
    if image.nil?
      "/images/nophoto_" + size + ".gif"
    else
      url_for_file_column(self, "image", size)
    end
  end

  def mini_pic
    pic("mini")
  end

  def thumb_pic
    pic("thumb")
  end

  def med_pic
    pic("medium")
  end

  def email
    email_address
  end

  # def email_address
  #   current_address ? current_address.email : user.try(:username)
  # end

  # [email1, email2, email3] => primary email, or email
  def email_address
    (email_addresses.where(primary: true).first || email_addresses.first).try(:email) ||
      current_address.try(:email) ||
      permanent_address.try(:email) ||
      user.try(:username)
  end

  # Sets the primary email address in email_addresses table
  def primary_email_address=(email)
    old_primaries = email_addresses.select{ |email| email.primary == true }
    old_primaries.each do |old_primary|
      old_primary.primary = 0
      old_primary.save!
    end

    old_email_record = email_addresses.select{ |email_record| email_record.email == email }.first
    if old_email_record
      old_email_record.primary = 1
      old_email_record.save!
    else
      EmailAddress.create!(:email => email, :person_id => self.id, :primary => 1)
    end
  end

  # Sets a phone number in the phone_numbers table
  def set_phone_number(phone, location, primary=false, extension=nil)
    if primary
      old_primaries = phone_numbers.select{ |phone| phone.primary == true }
      old_primaries.each do |old_primary|
        old_primary.primary = 0
        old_primary.save!
      end
    end

    old_phone_record = phone_numbers.select{ |phone| phone.location == location }.first
    if old_phone_record
      old_phone_record.number = phone
      old_phone_record.extension = extension
      old_phone_record.primary = primary
      old_phone_record.save!
    else
      PhoneNumber.create!(:number => phone, :location => location, :extension => extension, :primary => primary, :person_id => self.id)
    end
  end

  # This method shouldn't be needed because nightly updater should fill this in
  def is_secure?
    isSecure == 'T'
  end

  # Find an exact match by email
  def self.find_exact(person, address)
    # try by address first
    person = Person.where("#{Address.table_name}.email = ?", address.email).includes(:current_address).references(:current_address).first
    # then try by username
    person ||= Person.where("#{User.table_name}.username = ?", address.email).includes(:user).references(:user).first
    person
  end

  # Make sure account numbers are 9 or 10 digits long
  def self.fix_acct_no(acct_no)
    result = acct_no
    if !acct_no.blank?
      fix_length = 9
      if acct_no.ends_with?("S") || acct_no.ends_with?("s")
        fix_length = 10
      end
      pad = fix_length - acct_no.length
      result = "0" * pad + acct_no if pad > 0
    end
    result
  end

  def all_team_members(remove_self = false)
    my_local_level_ids = teams.collect &:id
    mmtm = TeamMember.where(:teamID => my_local_level_ids).joins(:person).order("lastName, firstName ASC")
    people = mmtm.collect(&:person).flatten.uniq
    people.delete(self) if remove_self
    return people
  end

  def to_s
    informal_full_name
  end

  def apply_omniauth(omniauth)
    self.firstName ||= omniauth['first_name']
    self.lastName ||= omniauth['last_name']
  end

  def check_region
    if self[:campus] && target_area && self[:region] != target_area.region
      self[:region] = target_area.region unless self[:region] == target_area.region
      self.universityState = target_area.state
    end
  end

  def phone
    if current_address
      return current_address.cellPhone if current_address.cellPhone.present?
      return current_address.homePhone if current_address.homePhone.present?
      return current_address.workPhone if current_address.workPhone.present?
    else
      ''
    end
  end

  def account_balance
    result = nil
    if user && user.balance_bookmark
      result = user.balance_bookmark.value
    end
    result
  end

  def updated_at() dateChanged end
  def updated_by() changedBy end
  def created_at() dateCreated end
  def created_by() createdBy end

  def async_push_to_global_registry
    attributes_to_push['account_number'] = account_no
    attributes_to_push['gender'] = human_gender
    attributes_to_push['marital_status'] = marital_status
    attributes_to_push['is_secure'] = is_secure?
    if birth_date.present?
      year, month, day = birth_date.to_s(:db).split('-').map(&:to_i)
      if month > 0 && day > 0
        attributes_to_push['birth_year'] = year if year > 0
        attributes_to_push['birth_month'] = month
        attributes_to_push['birth_day'] = day
      end
    end

    attributes_to_push['authentication'] = {}

    if user
      attributes_to_push['authentication']['relay_guid'] = user.globallyUniqueID if user.globallyUniqueID.present?
      attributes_to_push['authentication']['facebook_uid'] = user.fb_user_id if user.fb_user_id.present?
    end

    super
  end

  def self.skip_fields_for_gr
    %w[person_id ministry strategy organization_tree_cache org_ids_cache siebel_contact_id account_no minor number_children is_child bio image occupation blogfeed cru_commons_invite cru_commons_last_login date_created date_changed created_by changed_by fk_ssm_user_id fk_staff_site_profile_id fk_spouse_id fk_child_of level_of_school staff_notes donor_number url primary_campus_involvement_id mentor_id last_attended fb_uid date_attributes_updated balance_daily sp_gcx_site birth_date global_registry_id]
  end

  def self.columns_to_push
    super
    @columns_to_push += [{name: 'account_number', type: :string},
                         {name: 'username', type: :string},
                         {name: 'birth_year', type: :integer},
                         {name: 'birth_month', type: :integer},
                         {name: 'birth_day', type: :integer}
    ]
    @columns_to_push.each do |column|
      column[:type] = 'boolean' if column[:name] == 'is_secure'
    end
  end

  def self.global_registry_entity_type_name
    'person'
  end

end
