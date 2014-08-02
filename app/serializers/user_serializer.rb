require_dependency 'cru_enhancements'
class UserSerializer < ActiveModel::Serializer
  HAS_MANY = [:authentications]
  include CruEnhancements

  attributes :id, :username, :created_at, :updated_at
end
