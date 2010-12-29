class MovementsController < ApplicationController
  def edit
    @movement = Activity.find(params[:id])
    @location = @movement.target_area
    @statuses = Activity.visible_statuses
    @teams = Team.from_region(@location.region)
  end
end
