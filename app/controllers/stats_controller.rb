class StatsController < ApplicationController
  #TODO: Refactor some before_filters
  def index
    @current_week = Time.now.traditional_beginning_of_week
    @requested_week = Time.parse(params[:date]).traditional_beginning_of_week if params[:date]
    @requested_week ||= @current_week
    @movements = current_user.activities
    render :movement
  end
  
  # TODO: Should compare with Java version to make sure I didn't miss anything...
  def movement
    @current_week = Time.now.traditional_beginning_of_week
    @requested_week = Time.parse(params[:date]).traditional_beginning_of_week if params[:date]
    @requested_week ||= @current_week
    @movements = [Activity.find(params[:movement_id])]
    @movements.first.add_bookmark_for(current_user)
  end
  
  def update
    @requested_week = Time.parse(params[:date]).traditional_beginning_of_week if params[:date]
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
      date = "?date=" + @requested_week.to_s if @requested_week
      redirect_to stats_path + date.to_s, :notice => "Your stats have been saved successfully."
    else
      render :movement
    end
  end
end
