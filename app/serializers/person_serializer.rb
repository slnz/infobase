require_dependency 'cru_enhancements'
class PersonSerializer < ActiveModel::Serializer
  HAS_MANY = [:phone_numbers, :email_addresses]
  HAS_ONE = [:current_address]
  include CruEnhancements

  attributes :id, :account_no, :last_name, :gender, :region,
             :created_at, :updated_at,
             :ministry, :strategy, :global_registry_id, :user_id

  def attributes
    hash = super
    hash['first_name'] = object.nickname
    hash['is_staff'] = object.isStaff?
    hash['is_secure'] = %w(T I).include?(object.isSecure)
    hash['gender'] = object.human_gender
    hash
  end
end
