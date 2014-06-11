require 'cru_lib/global_registry_methods'
class Ministry < ActiveRecord::Base
  include Sidekiq::Worker
  include CruLib::GlobalRegistryMethods
  default_scope -> { order(:name) }

  def to_s
    name
  end
end
