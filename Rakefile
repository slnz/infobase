# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Infobase::Application.load_tasks

desc "runs simplecov report"
task :cov do
  sh 'bundle exec rake spec COVERAGE=true'
end 
