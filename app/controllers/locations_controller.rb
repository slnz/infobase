class LocationsController < ApplicationController
  before_filter :setup
  before_filter :get_location, :only => [:show, :edit, :update]
  before_filter :search_options, :only => [:new, :edit, :search]
  before_filter :populate_breadcrumbs, :only => [:show, :edit]
  
  def index
    @regions = Region.standard_regions
    @strategies = Activity.visible_strategies
  end
  
  def show
    if @location.blank? || @location.type == "Event"
      redirect_to locations_path
      return
    end
    @open_strategies = Activity.determine_open_strategies(@location)
    @title = "Infobase - " + @location.name
  end
  
  def new
    @location = TargetArea.new
    @location.attributes = params[:target_area]
    @name_options = {}
    @title = "Infobase - Propose New Location"
  end
  
  def create
    @location = TargetArea.new
    @location.attributes = params[:target_area]
    if @location.valid?
      if @info_user.can_create_locations?
        @location.save!
        redirect_to location_path(@location), :notice => "Location was created successfully."
      else
        host = request.host_with_port
        ProposeMailer.propose_location(@location, current_user.person, host).deliver
        redirect_to locations_path, :notice => "Your request was submitted successfully."
      end
    else
      search_options
      @name_options = {}
      render :new
      @title = "Infobase - Propose New Location"
    end
  end
  
  def edit
    @name_options = {:readonly => true}
    @title = "Infobase - Edit " + @location.name
  end
  
  def update
    @location.update_attributes(params[:target_area])
    if @location.errors.empty?
      redirect_to location_path(@location), :notice => "#{@location.name} was updated successfully."
    else
      search_options
      populate_breadcrumbs
      @name_options = {:readonly => true}
      render :edit
      @title = "Infobase - Edit" + @location.name
    end
  end
  
  def search
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
    render :search_results
  end
  
  def search_results
    if params[:namecity].blank? && params[:name].blank? && params[:city].blank? && params[:state].blank? && params[:country].blank? && params[:regions].blank? && params[:strategies].blank?
      redirect_to search_locations_path, :notice => "You must fill in at least one search option."
    end
    if (!params[:name].blank? && params[:name].size < 3) || (!params[:namecity].blank? && params[:namecity].size < 3)
      redirect_to search_locations_path, :notice => "You must fill in at least three letters of the name."
    end
    
    @locations = TargetArea.where("isClosed is null or isClosed <> 'T'").where("eventType is null or eventType <=> ''").includes(:activities).order(:name)
    if !params[:namecity].blank?
      @locations = @locations.where("name like ? OR city like ? OR infoUrl like ?", "%#{params[:namecity]}%", "#{params[:namecity]}%", "%#{params[:namecity]}%")
    end
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
    
    def get_location
      begin
        @location = TargetArea.find(params[:id])
      rescue
        @location = nil
      end
    end
    
    def populate_breadcrumbs
      if @location
        @region = @location.region
        @state = @location.state unless @location.country != "USA"
        @country = @location.country unless @location.country == "USA" || @location.country.blank?
        @city = @location.city
      end
    end
    
    def perform_search
      params[:regions] = [params[:region]]
      search_results
      render :search_results
    end
end
