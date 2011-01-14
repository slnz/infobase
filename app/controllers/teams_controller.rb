class TeamsController < ApplicationController
  before_filter :setup
  before_filter :search_options, :only => [:search]
  before_filter :populate_breadcrumbs, :only => []
  
  def index
    @regions = Region.standard_regions
    @strategies = Activity.visible_strategies
  end

  def show
    @team = Team.find(params[:id])
  end

  def search_results
    if params[:name].blank? && params[:city].blank? && params[:state].blank? && params[:country].blank? && params[:regions].blank? && params[:strategies].blank?
      redirect_to search_teams_path, :notice => "You must fill in at least one search option."
    end
    if !params[:name].blank? && params[:name].size < 3
      redirect_to search_teams_path, :notice => "You must fill in at least three letters of the name."
    end
    
    @teams = Team.where("isActive = 'T'").order(:name)
    if !params[:name].blank?
      @teams = @teams.where("name like ?", "%#{params[:name]}%")
    end
    if !params[:city].blank?
      @teams = @teams.where("city like ?", "#{params[:city]}%")
    end
    if !params[:state].blank?
      @teams = @teams.where("state = ?", params[:state])
    end
    if !params[:country].blank?
      @teams = @teams.where("country = ?", params[:country])
    end
    if !params[:regions].blank?
      @teams = @teams.where("region IN (?)", params[:regions])
    end
    if !params[:strategies].blank?
      @teams = @teams.where("lane IN (?)", params[:strategies])
    end
    @title = "Infobase - Search Results"
  end
  
  private
    def setup
      @menubar = "ministry"
      @submenu = "teams"
      @title = "Infobase - Team Home"
    end

    def populate_breadcrumbs
      @region = @team.region
      @state = @team.state unless @team.country != "USA"
      @country = @team.country unless @team.country == "USA" || @team.country.blank?
      @city = @team.city
    end
end
