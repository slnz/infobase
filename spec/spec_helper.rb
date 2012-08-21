require 'simplecov'

if ENV["COVERAGE"]
  SimpleCov.start 'rails' do
    add_filter 'vendor'
  end
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'factory_girl_rails'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # make terminal test results colorful
  config.color_enabled = true

  config.include FactoryGirl::Syntax::Methods

  # Remove records from database before and after test suite is run
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.use_transactional_fixtures = true

  config.infer_base_class_for_anonymous_controllers = true

  config.order = "random"
end
