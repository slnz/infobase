source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'
gem 'jquery-rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'#, '~> 0.2.0'
gem 'acts_as_state_machine'
gem 'dynamic_form'
gem 'dalli'
gem 'paperclip'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano_colors'

# To use debugger
# gem 'ruby-debug'

gem 'hoptoad_notifier'
group :production do
  gem 'activerecord-oracle_enhanced-adapter', '1.3.2' #1.4.0 doesn't work, see: https://github.com/rsim/oracle-enhanced/issues/85
  gem 'ruby-oci8'
  gem 'rack-google_analytics', :require => "rack/google_analytics"
end
gem 'multi_json'

group :assets do
  gem 'therubyracer'
  gem 'uglifier'
end

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri', '1.4.1'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
