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
  
  def sp
    @project_name = params[:name]
    region = params[:region] if Region.campus_region_codes.include?(params[:region])
    strategy = params[:strategy]
    project_email = params[:email]
    is_secure = params[:isSecure] == 'T'
    @period_begin = Date.parse(params[:periodBegin])
    @period_end = Date.parse(params[:periodEnd])
    @year = params[:year]
    @year ||= @period_begin.year # if year didn't come through params
    @redirect = params[:redirect]
    sp_project_id = params[:eventKeyID]
    @strategies = {"" => ""}.merge(Activity.visible_strategies.invert)
    
    ta = TargetArea.target_area_for_sp(sp_project_id, @project_name, region, is_secure, project_email)
    activity = Activity.movement_for_sp(ta, strategy)
    @movements = [activity]
  end

  def update
    @requested_week = Time.parse(params[:date]).traditional_beginning_of_week if params[:date]
    @username = current_user.username
    @strategy = params[:strategy]
    @redirect = params[:redirect]
    @stats = []
    params[:stat].each_key do |key|
      stats = params[:stat][key]
      @movement = Activity.find(stats[:fk_Activity])
      @movement.update_attribute(:strategy, @strategy) if @strategy
      if stats[:sp_year]
        stat = @movement.get_sp_stat_for(stats[:sp_year], Date.parse(stats[:periodBegin]), Date.parse(stats[:periodEnd]), stats[:peopleGroup])
      else
        stat = @movement.get_stat_for(Date.parse(stats[:periodBegin]), stats[:peopleGroup])
      end
      stats[:updated_by] = @username
      stat.attributes = stats
      stat.save
      if !stat.errors.empty?
        @stats << stat
        @current_week = Date.parse(stats[:periodBegin])
      end
    end
    if @stats.empty? && @redirect
      redirect_to @redirect
    elsif @stats.empty?
      date = "?date=" + @requested_week.to_s if @requested_week
      redirect_to stats_path + date.to_s, :notice => "Your stats have been saved successfully."
    else
      render :movement
    end
  end
end
