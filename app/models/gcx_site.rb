require 'gcx_site_name_validator'

class GcxSite
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :title

  validates :name, presence: true, gcx_site_name: true, format: /^[a-z][a-z0-9_\-]{2,79}$/i
  validates :title, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end

