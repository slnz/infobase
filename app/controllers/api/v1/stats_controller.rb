class Api::V1::StatsController < Api::V1::BaseController
  skip_before_filter :verify_authenticity_token

  def activity
    activity = Activity.where("activityid = ?", params[:activity_id]).first
    
    begin_date = Date.parse(params[:begin_date])
    end_date = Date.parse(params[:end_date])
    
    if activity
      @stats = activity.get_stats_for_dates(begin_date, end_date)
    else
      @stats = []
    end
    respond_with @stats, :root => "statistics"
  end

  def index
    show
  end
  
  def show
    activity = Activity.where("activityid = ?", params[:activity_id]).first
    
    date = Date.parse(params[:date])

    if activity
      @stat = activity.get_stat_for(date)
    else
      @stat = nil
    end
    respond_with [@stat], :root => "statistics"
  end
  
  def collate_stats
    begin_date = Date.parse(params[:begin_date])
    end_date = Date.parse(params[:end_date])
    semester_date = Date.parse(params[:semester_date])
    activity_ids = params[:activity_ids]
    
    report = InfobaseReport.create_report(begin_date, end_date, semester_date, activity_ids)

    respond_with report.rows.first
  end
  
  def movement_stages
    activity_ids = params[:activity_ids]
    query = Activity.where("ActivityID in (?)", activity_ids).count(:group => "status")
    
    result = {}
    query.each_key do |key|
      result[Activity.statuses[key]] = query[key]
    end

    result = {"statistics" => result}

    respond_with result do |format|
      format.json {
        render json: result
      }
    end
  end
  
  def create
    @user ||= "API"
    @stats = []
    params[:statistics].each do |stats|
      @movement = Activity.find(stats[:activity_id])
      stat = @movement.get_stat_for(Date.parse(stats[:period_begin]))
      stats[:updated_by] = @user
      stats.delete(:id) # Just in case an ID has been passed in; We're only creating records
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