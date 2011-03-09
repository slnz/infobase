class StatsController < ApplicationController
  def movement
    @current_week = Time.now.traditional_beginning_of_week
    @movement = Activity.find(params[:movement_id])
    @location = TargetArea.find(params[:location_id])
    @stats = [@movement.get_stat_for(@current_week)]
  end
  
  def update
    @stats = []
    params[:stat].each_key do |key|
      stats = params[:stat][key]
      @movement = Activity.find(stats[:fk_Activity])
      stat = @movement.get_stat_for(Date.parse(stats[:periodBegin]), stats[:peopleGroup])
      stat.attributes = stats
      stat.save
      if !stat.errors.empty?
        @stats << stat
        @current_week = Date.parse(stats[:periodBegin])
      end
    end
    if @stats.empty?
      redirect_to stats_path, :notice => "Your stats have been saved successfully."
    else
      render :movement
    end
  end
end
