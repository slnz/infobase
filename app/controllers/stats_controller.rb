class StatsController < ApplicationController
  def location
    @current_week = Time.now.beginning_of_week.to_date - 1.day # beginning of week returns Monday, and we want Sunday
    @movement = Activity.find(params[:movement_id])
    @location = TargetArea.find(params[:location_id])
    @stats = @movement.last_fifteen_stats
    @stat = @movement.get_stat_for(@current_week)
  end
end
