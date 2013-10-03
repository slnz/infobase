Airbrake.configure do |config|
  config.api_key     = 'caabd0879fd1419cd67b95e32061931a'
  config.host        = 'errors.uscm.org'
  config.port        = 443
  config.secure      = config.port == 443
end