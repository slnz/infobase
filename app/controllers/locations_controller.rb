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
  
  private
    def setup
      @menubar = "ministry"
      @submenu = "locations"
      @title = "Infobase - Location Home"
    end
end
