class HomeController < ApplicationController
  before_filter :setup
  
  def search
    type = params[:type]
    case type
    when "people"
      redirect_to search_results_people_path(:name => params[:name])
    when "locations"
      redirect_to search_results_locations_path(:namecity => params[:name])
    when "teams"
      redirect_to search_results_teams_path(:namecity => params[:name])
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
