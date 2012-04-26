class TeamsController < ApplicationController
  before_filter :setup
  before_filter :get_team, :only => [:show, :edit, :update, :add_member, :remove_member, :search_members, :search_members_results, :new_member, :create_member, :add_leader, :remove_leader]
  before_filter :search_options, :only => [:new, :edit, :search]
  before_filter :populate_breadcrumbs, :only => [:show, :edit, :add_member, :remove_member, :search_members, :search_members_results, :new_member]
  
  def index
    @regions = Region.campus_regions
    @strategies = Activity.visible_team_strategies
  end

  def show
    @reports_link = team_report_path(@team, {:event_type => "campus", :from => last_august(), :to => Date.today.to_s, :strategies => Activity.visible_strategies.keys})
  end
  
  def new
    @team = Team.new
    @team.attributes = params[:team]
    @strategies = Activity.strategies
    @title = "Infobase - Propose New Team"
  end

  def create
    @team = Team.new
    @team.attributes = params[:team]
    if @team.valid?
      if @info_user.can_create_teams?
        @team.isActive = "T"
        @team.save!
        redirect_to team_path(@team), :notice => "Team was created successfully."
      else
        host = request.host_with_port
        ProposeMailer.propose_team(@team, current_user.person, host).deliver
        redirect_to teams_path, :notice => "Your proposed team has been submitted for approval. This manual process may take a few days."
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
  
  def add_member
    member = Person.not_secure.find(params[:person_id])
    if @info_user.can_add_team_members? || @current_user.person == member || @team.is_leader?(@current_user.person)
      if !@team.people.include?(member)
        @team.people << member
      end
      redirect_to team_path(@team), :notice => "Team Member was successfully added."
    else
      redirect_to team_path(@team), :notice => "You do not have permission to add this team member."
    end
  end
  
  def remove_member
    member = Person.find(params[:person_id])
    if @info_user.can_remove_team_members? || @current_user.person == member || @team.is_leader?(@current_user.person)
      @team.people.delete(member)
      redirect_to team_path(@team), :notice => "Team Member was successfully removed."
    else
      redirect_to team_path(@team), :notice => "You do not have permission to remove this team member."
    end
  end
  
  def search_members_results
    @name = params[:name]
    if !@name.blank? && @name.size > 1
      query = @name.strip.split(' ')
      first = query.first
      last = query.last
      @results = Person.not_secure.includes(:current_address).where(Address.table_name + ".email is not null").
        order(:lastName).order(:firstName)
      if query.size > 1 #search both last AND first names, TODO: refactor into Person class
        @results = @results.where(Person.table_name + ".lastName like ?", "#{last}%")
        @results = @results.where(Person.table_name + ".firstName like ? or " + Person.table_name + ".preferredName like ?", "#{first}%", "#{first}%")
      else
        @results = @results.where(Person.table_name + ".lastName like ? or " + Person.table_name + ".firstName like ? or " + Person.table_name + ".preferredName like ?", "#{last}%", "#{first}%", "#{first}%")
      end
      @results = @results - @team.people
      render :search_members
    else
      flash.now[:notice] = "You must type at least 2 letters."
      render :search_members
    end
  end
  
  def new_member
    if @info_user.can_add_team_members? || @team.is_leader?(@current_user.person)
      @person = Person.new
      @person.current_address = Address.new
    else
      redirect_to team_path(@team), :notice => "You do not have permission to add team members."
    end
  end
  
  def create_member
    if @info_user.can_add_team_members? || @team.is_leader?(@current_user.person)
      @person = Person.new
      @person.current_address = Address.new
      @person.current_address.addressType = "current"
      @person.current_address.attributes = params[:person][:address]
      params[:person].delete(:address)
      @person.attributes = params[:person]
      if @person.current_address.valid? && @person.valid? && !@person.lastName.blank? && !@person.email.blank? && !@person.phone.blank?
        @person.save
        params[:person_id] = @person.personID
        add_member
      else
        if @person.lastName.blank?
          @person.errors.add(:last_name, "can't be blank")
        end
        if @person.email.blank?
          @person.errors.add(:email, "can't be blank")
        end
        if @person.phone.blank?
          @person.errors.add(:phone, "can't be blank")
        end
        render :new_member
      end
    else
      redirect_to team_path(@team), :notice => "You do not have permission to add team members."
    end
  end
  
  def validate_name
    data = Team.find_by_name_and_isActive(params[:name].strip, 'T')
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
  
  def add_leader
    if @info_user.can_add_team_leaders?
      person = Person.find(params[:person_id])
      if @team.add_leader(person)
        redirect_to team_path(@team), :notice => "Team Leader was successfully added."
      else
        redirect_to team_path(@team), :notice => "Team doesn't contain that Team Member."
      end
    else
      redirect_to team_path(@team), :notice => "You do not have permission to add team leaders."
    end
  end
  
  def remove_leader
    if @info_user.can_add_team_leaders?
      person = Person.find(params[:person_id])
      if @team.remove_leader(person)
        redirect_to team_path(@team), :notice => "Team Leader was successfully removed."
      else
        redirect_to team_path(@team), :notice => "Team doesn't contain that Team Member."
      end
    else
      redirect_to team_path(@team), :notice => "You do not have permission to remove team leaders."
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
      @title = "Infobase - Teams in " + Country.full_name(@country).to_s
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
      redirect_to search_teams_path, :notice => "You must fill in at least one search option."
    end
    if (!params[:name].blank? && params[:name].size < 3) || (!params[:namecity].blank? && params[:namecity].size < 3)
      redirect_to search_teams_path, :notice => "You must fill in at least three letters of the name."
    end
    
    @teams = Team.active.order(:name)
    if !params[:namecity].blank?
      @teams = @teams.where("name like ? OR city like ?", "%#{params[:namecity]}%", "#{params[:namecity]}%")
    end
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
