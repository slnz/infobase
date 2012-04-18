class StatsController < ApplicationController
  before_filter :setup
  before_filter :get_date_params, :only => [:index, :movement]  
  before_filter :get_event_params, :only => [:sp, :crs]
  
  def index
    all_movements = current_user.activities
    @movements = []
    all_movements.each do |movement|
      @movements << movement if movement.is_active?
    end
    render :movement
  end
  
  def movement
    @movements = [Activity.find(params[:movement_id])]
    @movements.first.add_bookmark_for(current_user)
  end
  
  def sp
    @submenu = "events"
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
    @submenu = "events"
    @strategy = Activity.interpret_strategy_from_crs(@strategy)
    ta = TargetArea.target_area_for_event("C2", @event_id, @name, @region, @is_secure, @email)
    activity = Activity.movement_for_event(ta, @period_begin, @strategy)
    @movements = [activity]
    @strategies = {"" => ""}.merge(Activity.event_strategies.invert)
    @type = "C2"
    render :event
  end
  
  def digital
    @submenu = "events"
    @strategies = {"" => ""}.merge(Activity.event_strategies.invert)
    @strategy ||= "EV" #default strategy
    @events = {"" => ""}.merge(TargetArea.special_events_hash)
    @types = {"Conference (that isn't in CRS)" => TargetArea.other_conference, "Website" => TargetArea.website, "Other" => TargetArea.other}
    @regions = {"" => ""}.merge(Region.standard_regions_hash)
    @stat = Statistic.new
  end
  
  def create_digital
    if check_digital_params
      ta = TargetArea.target_area_for_event(@type, nil, @name, @region, "F", nil, @event)
      activity = ta.get_event_activity(@from_date, @strategy)
      @stats = []
      stats = params[:stat][:stat]
      stat = activity.get_event_stat_for(@from_date, @to_date)
      if stat.id # stat record already exists
        @old_stat = stat
        @new_stat = stats
        render :confirm_digital
        return
      end
      stat.add_stats(stats)
      stat.updated_by = @username
      stat.save
      if !stat.errors.empty?
        @stats << stat
      end
      if @stats.empty?
        redirect_to digital_stats_path, :notice => "Your stats have been saved successfully."
      else
        digital
        render :digital
      end
    else # Bad params
      digital
      render :digital
    end
  end
  
  def confirm_digital
    old_stat_id = params[:old_stat]
    old_stat = Statistic.find(old_stat_id)
    new_stat = params[:stat][:stat]
    old_stat.add_stats(new_stat)
    if old_stat.periodBegin > Date.parse(params["periodBegin"])
      old_stat.periodBegin = Date.parse(params["periodBegin"])
    end
    if old_stat.periodEnd < Date.parse(params["periodEnd"])
      old_stat.periodEnd = Date.parse(params["periodEnd"])
    end
    old_stat.updated_by = current_user.username
    old_stat.save
    @stats = []
    if !old_stat.errors.empty?
      @stats << old_stat
    end
    if @stats.empty?
      redirect_to digital_stats_path, :notice => "Your stats have been saved successfully."
    else
      digital
      render :digital
    end
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
      if !stats[:sp_year].blank?
        stat = @movement.get_sp_stat_for(stats[:sp_year], Date.parse(stats[:periodBegin]), Date.parse(stats[:periodEnd]), stats[:peopleGroup])
      elsif @redirect
        stat = @movement.get_crs_stat_for(Date.parse(stats[:periodBegin]), Date.parse(stats[:periodEnd]), stats[:peopleGroup])
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
  
  def setup
    @menubar = "stats"
    @submenu = "stats"
  end
  
  def get_date_params
    @current_week = Time.now.traditional_beginning_of_week
    @requested_week = Time.parse(params[:date]).traditional_beginning_of_week if params[:date]
    @requested_week ||= @current_week
  end
  
  def get_event_params
    @name = params[:name]
    @region = params[:region] if Region.campus_region_codes.include?(params[:region])
    @strategy = params[:strategy]
    @strategy = "EV" if @strategy.blank?
    @email = params[:email]
    @event_id = params[:eventKeyID]
    @is_secure = params[:isSecure].to_s == 'T'
    @period_begin = Date.parse(params[:periodBegin])
    @period_end = Date.parse(params[:periodEnd])
    @redirect = params[:redirect]
  end
  
  def check_digital_params
    @event = params[:event]
    @type = params[:type]
    @name = params[:name]
    @region = params[:region]
    @strategy = params[:strategy]
    @from_date = Date.civil(params["from_date(1i)"].to_i, params["from_date(2i)"].to_i, params["from_date(3i)"].to_i)
    @to_date = Date.civil(params["to_date(1i)"].to_i, params["to_date(2i)"].to_i, params["to_date(3i)"].to_i)
    @username = current_user.username

    result = true
    if @event.blank? && @name.blank?
      flash.now[:notice] = "You must select an ongoing event or type in an event name."
      result = false
    end
    if result && @strategy.blank?
      flash.now[:notice] = "You must select a strategy."
      result = false
    end
    if result # check to make sure stats have been entered
      result = false
      stat = params[:stat][:stat]
      stat.each_key do |key|
        if !stat[key].blank?
          result = true
        end
      end
      unless result
        flash.now[:notice] = "You must enter at least one stat."
      end
    end
    if result # check to make sure stats are valid
      stats = params[:stat][:stat]
      stat = Statistic.new(stat)
      if !stat.valid?
        @stats = [stat]
        result = false
      end
    end
    result
  end
end
