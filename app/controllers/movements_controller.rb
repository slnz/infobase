class MovementsController < ApplicationController
  before_filter :get_location
  before_filter :get_movement, :only => [:edit, :update]
  before_filter :populate_select_options, :only => [:edit]
  before_filter :get_user
  
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
      @movement.save_create_history(@user)
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
    @movement.update_attributes_add_history(params[:activity], @user)
    if @movement.errors.empty?
      redirect_to location_path(@location), :notice => "#{@location.name}, #{@movement.strategy} was updated successfully."
    else
      populate_select_options
      render :edit
    end
  end
  
  private
  
  def get_user
    @user = User.find(42602) # TODO: get actual user
  end
  
  def get_location
    @location = TargetArea.find(params[:location_id])
  end
  
  def get_movement
    @movement = Activity.find(params[:id])
    @location = @movement.target_area
  end
  
  def populate_select_options
    @statuses = Activity.visible_statuses
    @teams = Team.from_region(@location.region)
    @team_id = @movement.team.id if @movement.team
  end
end
