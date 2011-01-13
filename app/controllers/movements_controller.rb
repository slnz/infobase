class MovementsController < ApplicationController
  before_filter :setup, :get_location
  before_filter :get_movement, :except => [:new, :create]
  before_filter :populate_select_options, :only => [:edit]
  
  def new
    @movement = Activity.new_movement_for_strategy(@location, params[:strategy])
    if @movement.ActivityID
      redirect_to edit_location_movement_path(@location, @movement)
    end
    populate_select_options
    @movement.periodBegin = Time.now.to_date # Initialize date of change to today
  end
  
  def create
    @movement = Activity.new
    @movement.attributes = params[:activity]
    if @movement.valid?
      @movement.save_create_history(@current_user)
      redirect_to location_path(@location), :notice => "Your request was submitted successfully."
    else
      populate_select_options
      render :new
    end
  end
  
  def edit
    @movement.periodBegin = Time.now.to_date # Initialize date of change to today
  end
  
  def update
    @movement.update_attributes_add_history(params[:activity], @current_user)
    if @movement.errors.empty?
      redirect_to location_path(@location), :notice => "#{@location.name}, #{@movement.strategy} was updated successfully."
    else
      populate_select_options
      render :edit
    end
  end
  
  def add_contact
    @contact = Person.find(params[:id])
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
    @contact = Person.find(params[:id])
    if @info_user.can_delete_contacts? || @current_user.person == @contact
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
        includes(:current_address).where(Address.table_name + ".email is not null").
        order(:lastName).order(:firstName)
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
      @person.current_address.attributes = params[:person][:address]
      params[:person].delete(:address)
      @person.attributes = params[:person]
      if @person.current_address.valid? && @person.valid? && !@person.lastName.blank? && !@person.email.blank? && !@person.phone.blank?
        @person.save
        params[:id] = @person.personID
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
  
  private
  
  def get_location
    @location = TargetArea.find(params[:location_id])
  end
  
  def get_movement
    @movement = Activity.find(params[:movement_id]) if params[:movement_id]
    @movement ||= Activity.find(params[:id])
    @location = @movement.target_area
  end
  
  def populate_select_options
    @statuses = Activity.visible_statuses
    @teams = Team.from_region(@location.region)
    @team_id = @movement.team.id if @movement.team
  end

  def setup
    @menubar = "ministry"
    @submenu = "locations"
    @title = "Infobase - Location Home"
  end
end
