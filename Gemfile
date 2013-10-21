source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.0'

# Use sqlite3 as the database for Active Record
# gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

#gem 'common_engine', path: '/home/justin/cmde/work_rails/common_engine'
gem 'common_engine', git: 'https://github.com/CruGlobal/common_engine.git'
gem 'qe', git: 'https://github.com/CruGlobal/qe.git'
gem 'mysql2'
gem 'dynamic_form'
gem 'dalli'
gem 'paperclip'
gem 'active_model_serializers'
gem 'newrelic_rpm'
gem 'multi_json'
gem 'aasm'
gem 'airbrake'
gem 'coffee-script'
gem 'choices'
gem 'ox'
gem 'rest-client'

gem 'whenever'
gem 'awesome_print'
gem 'gcx_api', git: 'https://github.com/CruGlobal/gcx_api.git'
gem 'rest-client'
gem 'oj'

group :production do
  # gem 'ruby-oci8'
  # gem 'activerecord-oracle_enhanced-adapter'
  gem 'rack-google_analytics', :require => "rack/google_analytics"
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'guard-rails'
  gem 'rb-fsevent'
  gem 'database_cleaner'
  gem 'launchy'

  gem 'yard'
  gem 'simplecov', :require => false

  gem 'awesome_print'

  gem "better_errors"
  #gem "binding_of_caller"
end

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri', '1.4.1'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'
