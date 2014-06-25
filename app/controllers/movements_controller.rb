class MovementsController < ApplicationController
  before_filter :setup, :get_location
  before_filter :get_movement, :except => [:new, :create]
  
  def new
    @movement = Activity.new_movement_for_strategy(@location, params[:strategy])
    if @movement.ActivityID
      redirect_to edit_location_movement_path(@location, @movement)
    end
    populate_select_options(params[:strategy])
    @movement.periodBegin = Time.now.to_date # Initialize date of change to today
  end
  
  def create
    @movement = Activity.new
    @movement.attributes = activity_params
    if @movement.valid?
      @movement.save_create_history(@current_user)
      redirect_to location_path(@location), :notice => "Your request was submitted successfully."
    else
      populate_select_options(@movement.strategy)
      render :new
    end
  end
  
  def edit
    populate_select_options(@movement.strategy)
    @movement.periodBegin = Time.now.to_date # Initialize date of change to today
  end
  
  def update
    @movement.update_attributes_add_history(activity_params, @current_user.userID)
    if @movement.errors.empty?
      redirect_to location_path(@location), :notice => "#{@location.name}, #{@movement.strategy} was updated successfully."
    else
      populate_select_options(@movement.strategy)
      render :edit
    end
  end
  
  def add_contact
    @contact = Person.not_secure.find(params[:person_id])
    if @info_user.can_add_contacts? || @current_user.person == @contact
      if !@movement.contacts.include?(@contact)
        @movement.contacts << @contact
      end
      redirect_to location_path(@location), :notice => "Contact was successfully added."
    else
      redirect_to location_path(@location), :notice => "You do not have permission to add this contact."
    end
  end
  
  def remove_contact
    @contact = Person.find(params[:person_id])
    if @info_user.can_delete_contacts? || @current_user.person == @contact || @movement.team.is_leader?(@current_user.person)
      @movement.contacts.delete(@contact)
      redirect_to location_path(@location), :notice => "Contact was successfully removed."
    else
      redirect_to location_path(@location), :notice => "You do not have permission to remove this contact."
    end
  end
  
  def search_contacts
  end
  
  def search_contacts_results
    @last_name = params[:last_name]
    if !@last_name.blank? && @last_name.size > 1
      @results = Person.not_secure.where("lastName like ?", @last_name + '%').
        includes(:current_address).where(Address.table_name + ".email is not null").references(:current_address).
        order(:lastName).order(:firstName)
      @results = @results - @movement.contacts
      render :search_contacts
    else
      flash.now[:notice] = "You must type at least 2 letters."
      render :search_contacts
    end
  end
  
  def new_contact
    if @info_user.can_add_contacts?
      @person = Person.new
      @person.current_address = Address.new
    else
      redirect_to location_path(@location), :notice => "You do not have permission to add contacts."
    end
  end
  
  def create_contact
    if @info_user.can_add_contacts?
      @person = Person.new
      @person.current_address = Address.new
      @person.current_address.addressType = "current"
      @person.current_address.attributes = current_address_params
      params[:person].delete(:address)
      @person.attributes = person_params
      if @person.current_address.valid? && @person.valid? && !@person.lastName.blank? && !@person.email.blank? && !@person.phone.blank?
        @person.save
        params[:person_id] = @person.personID
        add_contact
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
        render :new_contact
      end
    else
      redirect_to location_path(@location), :notice => "You do not have permission to add contacts."
    end
  end
  
  def unbookmark
    @bookmark = @movement.get_bookmark_for(current_user)
    if @bookmark
      @bookmark.destroy
      if @bookmark.destroyed?
        redirect_to stats_path, :notice => "Bookmark successfully deleted."
      else
        redirect_to stats_path, :notice => "Unable to delete bookmark."
      end
    else
      redirect_to stats_path
    end
  end
  
  private
  
  def get_location
    @location = TargetArea.find(params[:location_id])
  end
  
  def get_movement
    @movement = Activity.find(params[:id])
    @location = @movement.target_area
  end
  
  def populate_select_options(strategy)
    if strategy == "WS"
      @statuses = Activity.wsn_statuses
    else
      @statuses = Activity.visible_statuses
    end
    if @location.city?
      @teams = Team.where(lane: Strategy.where(city: true).pluck(:abreviation))
    else
      @teams = Team.from_region(@location.region)
    end
    @team_id = @movement.team.id if @movement.team
  end

  def setup
    @menubar = "ministry"
    @submenu = "locations"
    @title = "Infobase - Location Home"
  end

  def activity_params
    params.fetch(:activity).permit(:strategy, :fk_targetAreaID, :status, :periodBegin, :fk_teamID, :url, :facebook)
  end

  def person_params
    params.fetch(:person).permit(:firstName, :lastName, :gender)
  end

  def current_address_params
    params.fetch(:person).fetch(:address).permit(:email, :homePhone)
  end
end
