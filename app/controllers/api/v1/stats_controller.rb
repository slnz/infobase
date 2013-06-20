class Api::V1::StatsController < ApplicationController
  skip_before_filter :cas_filter
  skip_before_filter AuthenticationFilter
  skip_before_filter :check_user
  skip_before_filter :current_user
  skip_before_filter :log_user
  respond_to :json
  
  def self.filters(kind = nil)
    all_filters = _process_action_callbacks
    all_filters = all_filters.select{|f| f.kind == kind} if kind
    all_filters.map(&:filter)
  end
 
  def self.before_filters
    filters(:before)
  end
 
  def self.after_filters
    filters(:after)
  end
 
  def self.around_filters
    filters(:around)
  end
  
  def activity
    activity = Activity.find(params[:activity_id])
    
    begin_date = Date.parse(params[:begin_date])
    end_date = Date.parse(params[:end_date])
    
    @stats = activity.get_stats_for_dates(begin_date, end_date)
    respond_with @stats, :root => "statistics"
  end
  
  def show
    activity = Activity.find(params[:activity_id])
    
    date = Date.parse(params[:date])

    @stat = activity.get_stat_for(date)
    respond_with [@stat], :root => "statistics"
  end
  
  def update
    @username = "API"
    @stats = []
    params[:statistics].each do |stats|
      @movement = Activity.find(stats[:activity_id])
      stat = @movement.get_stat_for(Date.parse(stats[:period_begin]))
      stats[:updated_by] = @username
      stat.attributes = stats
      stat.save
      if !stat.errors.empty?
        stat_hash = stat.attributes.merge({:errors => stat.errors.to_hash})
        @stats << stat_hash
      end
    end
    respond_with @stats do |format|
      format.json {
        render json: @stats, :root => "statistics"
      }
    end
  end      
end