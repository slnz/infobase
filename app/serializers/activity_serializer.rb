require_dependency 'cru_enhancements'

class ActivitySerializer < ActiveModel::Serializer
  has_one :target_area

  attributes :id, :status, :period_begin, :strategy, :url, :facebook, :created_at, :updated_at, :gcx_site,
             :target_area_id, :team_id
end
