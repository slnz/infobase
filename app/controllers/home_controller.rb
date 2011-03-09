class HomeController < ApplicationController
  before_filter :setup
  before_filter :search_options, :only => :index
  
  def search
    type = params[:type]
    params[:search][:regions] = params[:regions]
    params[:search][:strategies] = params[:strategies]
    case type
    when "people"
      params[:search][:name] = params[:search][:namecity]
      redirect_to search_results_people_path(params[:search])
    when "locations"
      redirect_to search_results_locations_path(params[:search])
    when "teams"
      redirect_to search_results_teams_path(params[:search])
    else
      redirect_to :home
    end
  end
  
  def no
  end
  
  private
    def setup
      @menubar = "home"
    end
end
