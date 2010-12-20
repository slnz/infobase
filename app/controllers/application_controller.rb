class ApplicationController < ActionController::Base
  protect_from_forgery

  def search_options
    @search_types = {"Location" => search_locations_path, "Person" => search_people_path, "Team" => search_teams_path}
    @states = State::NAMES.insert(0,['',''])
    @countries = {"" => ""}.merge(Country.to_hash_US_first)
    @strategies = Activity.visible_strategies
    @regions = Region.campus_regions
    @title = "Infobase - Advanced Search"
  end
end
