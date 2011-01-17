class TeamsController < ApplicationController
  before_filter :setup
  before_filter :get_team, :only => [:show, :edit, :update]
  before_filter :search_options, :only => [:search]
  before_filter :populate_breadcrumbs, :only => [:show]
  
  def index
    @regions = Region.standard_regions
    @strategies = Activity.visible_team_strategies
  end

  def show
  end

  def region
    if params[:all]
      perform_search
    else
      @states = Team.select("distinct state").where("region = ?", @region).where("state is not null and state != ''").order(:state)
      @countries = Team.select("distinct country").where("region = ?", @region).where("country is not null and country != ''").order(:country)
      @title = "Infobase - Teams in " + Region.full_name(@region)
    end
  end
  
  def state
    if params[:all]
      perform_search
    else
      @cities = Team.select("distinct city").where("region = ?", @region).where("state = ?", @state).where("city is not null and city != ''").order(:city)
      @title = "Infobase - Teams in " + State.states[@state]
    end
  end
  
  def country
    if params[:all]
      perform_search
    else
      @region = params[:region]
      @country = params[:country]
      @cities = Team.select("distinct city").where("region = ?", @region).where("country = ?", @country).where("city is not null and city != ''").order(:city)
      @title = "Infobase - Teams in " + Country.full_name(@country)
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
      @region = params[:region]
      @state = params[:state]
      @country = params[:country]
      @city = params[:city]
      @title = "Infobase - Team Home"
    end
    
    def get_team
      @team = Team.find(params[:id])
    end

    def populate_breadcrumbs
      @region = @team.region
      @state = @team.state unless @team.country != "USA"
      @country = @team.country unless @team.country == "USA" || @team.country.blank?
      @city = @team.city
    end

    def perform_search
      params[:regions] = [params[:region]]
      search_results
      render :search_results
    end
end
