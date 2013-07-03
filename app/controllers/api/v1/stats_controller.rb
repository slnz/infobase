class Api::V1::StatsController < Api::V1::BaseController
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
  
  def create
    @user ||= "API"
    @stats = []
    params[:statistics].each do |stats|
      @movement = Activity.find(stats[:activity_id])
      stat = @movement.get_stat_for(Date.parse(stats[:period_begin]))
      stats[:updated_by] = @user
      stat.attributes = stats
      if stat.id.blank? # Only create records
        stat.save
      else
        stat.valid?
        errors = stat.errors
        if stat.id.present?
          errors["id"] = ["already present with value #{stat.id}"]
        end
      end
      if !stat.errors.empty?
        errors ||= stat.errors
        stat_hash = stat.attributes.merge({:errors => errors})
        @stats << stat_hash
      end
    end
    respond_with @stats do |format|
      format.json {
        render json: @stats, :root => "statistics"
      }
    end
  end
  
  def update
    @user ||= "API"
    @stats = []
    params[:statistics].each do |stats|
      @movement = Activity.find(stats[:activity_id])
      stat = @movement.get_stat_for(Date.parse(stats[:period_begin]))
      stats[:updated_by] = @user
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