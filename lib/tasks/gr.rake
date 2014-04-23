task :global => :environment do
  campus = Ministry.find_by(name: 'Campus Field Ministry')
  campus.async_push_to_global_registry

  regions = Region.all
  regions.map do |r|
    r.async_push_to_global_registry(campus.global_registry_id)
  end

  # create teams
  Team.find_each do |t|
    region = regions.detect {|r| r.abbrv = t.region}
    begin
      t.async_push_to_global_registry(region.global_registry_id)
    rescue RestClient::InternalServerError
      t.update_column(:global_registry_id, nil)
      t.async_push_to_global_registry(region.global_registry_id)
    end
  end

  # create target_areas
  TargetArea.find_each.each do |t|
    begin
      t.async_push_to_global_registry
    rescue RestClient::InternalServerError
      t.update_column(:global_registry_id, nil)
      t.async_push_to_global_registry
    end
  end

  # create activities
  Activity.find_each.each do |t|
    begin
      t.async_push_to_global_registry
    rescue RestClient::InternalServerError
      t.update_column(:global_registry_id, nil)
      t.async_push_to_global_registry
    end
  end

  # create statistics
  Statistic.find_each.each do |t|
    begin
      t.async_push_to_global_registry
    rescue RestClient::InternalServerError
      t.update_column(:global_registry_id, nil)
      t.async_push_to_global_registry
    end
  end

  # create team memberships
  Person.find_each do |t|
    begin
      t.async_push_to_global_registry
    rescue RestClient::InternalServerError
      t.update_column(:global_registry_id, nil)
      t.async_push_to_global_registry
    end
  end

  # create team memberships
  TeamMember.includes(:person, :team).find_each do |t|
    begin
      t.async_push_to_global_registry
    rescue RestClient::InternalServerError
      t.update_column(:global_registry_id, nil)
      t.async_push_to_global_registry
    end
  end
end