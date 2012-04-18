task :person => :environment do
  PersonUpdater.update_people_from_ps
end