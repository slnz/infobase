require_dependency 'cru_enhancements'

class TargetAreaSerializer < ActiveModel::Serializer
  attributes :id, :name, :type, :longitude, :latitude, :enrollment
end
