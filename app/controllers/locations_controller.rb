class LocationsController < ApplicationController
  before_filter :setup
  
  def index
    @regions = Region.standard_regions
    @strategies = Activity.strategies
  end
  
  def show
    @location = TargetArea.find(params[:id])
    @open_strategies = Activity.determine_open_strategies(@location)
    activities = @location.activities
    @title = "Infobase - " + @location.name
  end
  
  def search
    search_options
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
  end
  
  private
    def setup
      @menubar = "ministry"
      @submenu = "locations"
      @title = "Infobase - Location Home"
    end
end
