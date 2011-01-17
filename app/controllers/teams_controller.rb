class TeamsController < ApplicationController
  before_filter :setup
  before_filter :get_team, :only => [:show, :edit, :update]
  before_filter :search_options, :only => [:new, :edit, :search]
  before_filter :populate_breadcrumbs, :only => [:show]
  
  def index
    @regions = Region.campus_regions
    @strategies = Activity.visible_team_strategies
  end

  def show
  end
  
  def new
    @team = Team.new
    @team.attributes = params[:team]
    @name_options = {}
    @title = "Infobase - Propose New Team"
  end

  def create
    @team = Team.new
    @team.attributes = params[:team]
    if @team.valid?
      if @info_user.can_create_teams?
        @team.save!
        redirect_to team_path(@team), :notice => "Team was created successfully."
      else
        host = request.host_with_port
        ProposeMailer.propose_team(@team, current_user.person, host).deliver
        redirect_to teams_path, :notice => "Your request was submitted successfully."
      end
    else
      search_options
      @name_options = {}
      render :new
      @title = "Infobase - Propose New Team"
    end
  end
  
  def edit
    @name_options = {:readonly => true}
    @title = "Infobase - Edit " + @team.name
  end

  def update
    @team.update_attributes(params[:team])
    if @team.errors.empty?
      redirect_to team_path(@team), :notice => "#{@team.name} was updated successfully."
    else
      search_options
      populate_breadcrumbs
      @name_options = {:readonly => true}
      render :edit
      @title = "Infobase - Edit" + @team.name
    end
  end
  
  def region
    if params[:all]
      perform_search
    else
      @states = Team.active.select("distinct state").where("region = ?", @region).where("state is not null and state != ''").order(:state)
      @countries = Team.active.select("distinct country").where("region = ?", @region).where("country is not null and country != ''").order(:country)
      @title = "Infobase - Teams in " + Region.full_name(@region)
    end
  end
  
  def state
    if params[:all]
      perform_search
    else
      @cities = Team.active.select("distinct city").where("region = ?", @region).where("state = ?", @state).where("city is not null and city != ''").order(:city)
      @title = "Infobase - Teams in " + State.states[@state]
    end
  end
  
  def country
    if params[:all]
      perform_search
    else
      @region = params[:region]
      @country = params[:country]
      @cities = Team.active.select("distinct city").where("region = ?", @region).where("country = ?", @country).where("city is not null and city != ''").order(:city)
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
    
    @teams = Team.active.order(:name)
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
      @strategies = Activity.visible_team_strategies
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
