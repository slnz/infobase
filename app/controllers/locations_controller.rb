class LocationsController < ApplicationController
  before_filter :setup
  
  def index
    @regions = Region.standard_regions
    @strategies = Activity.visible_strategies
  end
  
  def show
    @location = TargetArea.find(params[:id])
    populate_breadcrumbs
    @open_strategies = Activity.determine_open_strategies(@location)
    activities = @location.activities
    @title = "Infobase - " + @location.name
  end
  
  def search
    search_options
    @title = "Infobase - Location Search"
  end
  
  def region
    if params[:all]
      perform_search
    else
      @states = TargetArea.select("distinct state").where("region = ?", @region).where("state is not null and state != ''").order(:state)
      @countries = TargetArea.select("distinct country").where("region = ?", @region).where("country is not null and country != ''").order(:country)
      @title = "Infobase - Locations in " + Region.full_name(@region)
    end
  end
  
  def state
    if params[:all]
      perform_search
    else
      @cities = TargetArea.select("distinct city").where("region = ?", @region).where("state = ?", @state).where("city is not null and city != ''").order(:city)
      @title = "Infobase - Locations in " + State.states[@state]
    end
  end
  
  def country
    if params[:all]
      perform_search
    else
      @region = params[:region]
      @country = params[:country]
      @cities = TargetArea.select("distinct city").where("region = ?", @region).where("country = ?", @country).where("city is not null and city != ''").order(:city)
      @title = "Infobase - Locations in " + Country.full_name(@country)
    end
  end
  
  def city
    perform_search
  end
  
  def ministry
    params[:strategies] = [params[:strategy]]
    search_results
    render :action => :search_results
  end
  
  def search_results
    @locations = TargetArea.where("isClosed is null or isClosed <> 'T'").where("eventType is null or eventType <=> ''").includes(:activities).order(:name)
    if !params[:name].blank?
      @locations = @locations.where("name like ?", "%#{params[:name]}%")
    end
    if !params[:city].blank?
      @locations = @locations.where("city like ?", "#{params[:city]}%")
    end
    if !params[:state].blank?
      @locations = @locations.where("state = ?", params[:state])
    end
    if !params[:country].blank?
      @locations = @locations.where("country = ?", params[:country])
    end
    if !params[:regions].blank?
      @locations = @locations.where("region IN (?)", params[:regions])
    end
    if !params[:strategies].blank?
      @locations = @locations.where(Activity.table_name + ".strategy IN (?)", params[:strategies])
    end
    @title = "Infobase - Search Results"
  end
  
  private
    def setup
      @menubar = "ministry"
      @submenu = "locations"
      @region = params[:region]
      @state = params[:state]
      @country = params[:country]
      @city = params[:city]
      @title = "Infobase - Location Home"
    end
    
    def populate_breadcrumbs
      @region = @location.region
      @state = @location.state unless @location.country != "USA"
      @country = @location.country unless @location.country == "USA"
      @city = @location.city
    end
    
    def perform_search
      params[:regions] = [params[:region]]
      search_results
      render :action => :search_results
    end
end
