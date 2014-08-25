require_dependency 'cru_enhancements'

class TeamSerializer < ActiveModel::Serializer
  HAS_MANY = [:people, :activities]
  include CruEnhancements

  attributes :id, :name, :lane, :note, :region, :address1, :address2, :city, :state, :zip, :country, :phone, :fax, :email, :url,
             :isActive, :created_at, :updated_at, :global_registry_id, :to_s

  def to_s
    object.to_s
  end

end
