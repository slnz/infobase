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
    @reports_link = location_report_path(@location, {:event_type => "campus", :from => last_august(), :to => Date.today.to_s, :strategies => Activity.visible_strategies.keys})
    @open_strategies = Activity.determine_open_strategies(@location)
    @title = "Infobase - " + @location.name
  end
  
  def new
    @location = TargetArea.new
    @location.attributes = target_area_params
    @title = "Infobase - Propose New Location"
  end
  
  def create
    @location = TargetArea.new
    @location.attributes = target_area_params
    if @location.valid?
      if @info_user.can_create_locations?
        @location.save!
        redirect_to location_path(@location), :notice => "Location was created successfully."
      else
        host = request.host_with_port
        ProposeMailer.propose_location(@location, current_user.person, host).deliver
        redirect_to locations_path, :notice => "Your proposed location has been submitted for approval. This manual process may take a few days.."
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
    @location.update_attributes(target_area_params)
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
  
  def validate_name
    data = TargetArea.find_by_name(params[:name].strip)
    if data.present?
      response = data.id == params[:id].to_i ? 2 : 1 
    else
      response = 0 
    end
    # 0 - Available
    # 1 - Used by others
    # 2 - Same as currentons
    render :text => response
  end
  
  def region
    if params[:all]
      perform_search
    else
      @states = TargetArea.open_school.select("distinct state").where("region = ?", @region).where("state is not null and state != ''").order(:state)
      @countries = TargetArea.open_school.select("distinct country").where("region = ?", @region).where("country is not null and country != ''").order(:country)
      @title = "Infobase - Locations in " + Region.full_name(@region)
    end
  end
  
  def state
    if State.states[@state]
      if params[:all]
        perform_search
      else
        @cities = TargetArea.open_school.select("distinct city").where("region = ?", @region).where("state = ?", @state).where("city is not null and city != ''").order(:city)
        @title = "Infobase - Locations in " + State.states[@state]
      end
    else # invalid state
      redirect_to location_region_path(@region)
    end
  end
  
  def country
    if params[:all]
      perform_search
    else
      @region = params[:region]
      @country = params[:country]
      @cities = TargetArea.open_school.select("distinct city").where("region = ?", @region).where("country = ?", @country).where("city is not null and city != ''").order(:city)
      @title = "Infobase - Locations in " + Country.full_name(@country).to_s
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
    if (!params[:name].blank? && params[:name].size < 2) || (!params[:namecity].blank? && params[:namecity].size < 2)
      redirect_to search_locations_path, :notice => "You must fill in at least two letters of the name."
    end
    
    @locations = TargetArea.open_school.includes(:activities).order(:name)
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
      @locations = @locations.where(Activity.table_name + ".strategy IN (?)", params[:strategies]).references(:activities)
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

    def target_area_params
      params.fetch(:target_area).permit(:region, :name, :altName, :abbrv, :address1, :address2, :city, :state, :zip, :country, :url, :infoUrl, :enrollment, :urlToLogo, :monthSchoolStarts, :monthSchoolStops, :isSecure, :type, :note, :gate) if params.has_key?(:target_area)
    end
end
