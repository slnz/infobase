class LocationsController < ApplicationController
  before_filter :setup
  
  def index
  end
  
  def show
    @location = TargetArea.find(params[:id])
    @title = "Infobase - " + @location.name
  end
  
  private
    def setup
      @menubar = "ministry"
      @submenu = "locations"
      @title = "Infobase - Location Home"
    end
end
