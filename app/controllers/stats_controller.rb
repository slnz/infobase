class StatsController < ApplicationController
  before_filter :get_date_params, :only => [:index, :movement]  
  before_filter :get_event_params, :only => [:sp, :crs]
  
  def index
    @movements = current_user.activities
    render :movement
  end
  
  def movement
    @movements = [Activity.find(params[:movement_id])]
    @movements.first.add_bookmark_for(current_user)
  end
  
  def sp
    @year = params[:year]
    @year ||= @period_begin.year # if year didn't come through params
    
    ta = TargetArea.target_area_for_event("SP", @event_id, @name, @region, @is_secure, @email)
    activity = Activity.movement_for_event(ta, @period_begin, @strategy)
    @movements = [activity]
    @strategies = {"" => ""}.merge(Activity.event_strategies.invert)
    @type = "SP"
    render :event
  end
  
  def crs
    @strategy = Activity.interpret_strategy_from_crs(@strategy)
    ta = TargetArea.target_area_for_event("C2", @event_id, @name, @region, @is_secure, @email)
    activity = Activity.movement_for_event(ta, @period_begin, @strategy)
    @movements = [activity]
    @strategies = {"" => ""}.merge(Activity.event_strategies.invert)
    @type = "C2"
    render :event
  end
  
  def digital
    @strategies = {"" => ""}.merge(Activity.event_strategies.invert)
    @events = {}
    @stat = Statistic.new
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
      if @redirect
        @strategies = {"" => ""}.merge(Activity.event_strategies.invert)
        @movements = [@stats.first.activity]
        render :event
      else
        render :movement
      end
    end
  end
  
  private
  
  def get_date_params
    @current_week = Time.now.traditional_beginning_of_week
    @requested_week = Time.parse(params[:date]).traditional_beginning_of_week if params[:date]
    @requested_week ||= @current_week
  end
  
  def get_event_params
    @name = params[:name]
    @region = params[:region] if Region.campus_region_codes.include?(params[:region])
    @strategy = params[:strategy]
    @email = params[:email]
    @event_id = params[:eventKeyID]
    @is_secure = params[:isSecure].to_s == 'T'
    @period_begin = Date.parse(params[:periodBegin])
    @period_end = Date.parse(params[:periodEnd])
    @redirect = params[:redirect]
  end
end
