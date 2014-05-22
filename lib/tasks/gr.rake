task :global => :environment do
  campus = Ministry.find_by(name: 'Campus Field Ministry')
  campus.async_push_to_global_registry

  regions = Region.all
  regions.map do |r|
    r.async_push_to_global_registry(campus.global_registry_id)
  end

  # create teams
  Team.find_each do |t|
    puts "Team: #{t.id}"
    region = regions.detect {|r| r.abbrv = t.region}
    t.async_push_to_global_registry(region.global_registry_id)
  end

  # create target_areas
  TargetArea.find_each do |t|
    puts "TargetArea: #{t.id}"
    t.async_push_to_global_registry
  end

  # create activities
  Activity.find_each do |t|
    puts "Activity: #{t.id}"
    t.async_push_to_global_registry
  end

  # create statistics
  Statistic.find_each do |t|
    puts "Statistic: #{t.id}"
    t.async_push_to_global_registry
  end

  # create team memberships
  Person.find_each do |t|
    puts "Person: #{t.id}"
    t.async_push_to_global_registry
  end

  EmailAddress.find_each do |t|
    puts "EmailAddress: #{t.id}"
    t.async_push_to_global_registry
  end

  # create team memberships
  TeamMember.includes(:person, :team).find_each do |t|
    puts "TeamMember: #{t.id}"
    t.async_push_to_global_registry
  end
end
