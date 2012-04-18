if Rails.env == "production"
  Infobase::Application.config.middleware.use("Rack::GoogleAnalytics", :web_property_id => "UA-325725-23")
end