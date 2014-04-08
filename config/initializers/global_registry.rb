require 'global_registry'

GlobalRegistry.configure do |config|
  config.access_token = Rails.configuration.gr_access_token
  config.base_url = Rails.configuration.gr_url
end
