class Api::V1::StatisticsController < Api::V1::BaseController

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
    statistics = StatisticFilter.new(params[:filters]).filter(Statistic.all)

    render render_options(statistics)
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

  def collate_stats_intervals
    begin_date = Date.parse(params[:begin_date])
    end_date = Date.parse(params[:end_date])
    activity_ids = params[:activity_ids]
    interval = params[:interval] if params.has_key?(:interval)
    interval ||= 1

    report = InfobaseReport.create_report_intervals(begin_date, end_date, activity_ids)

    response = {}
    report.rows.each do |row|
      response[row.name] = row
    end
    render json: response.to_json
  end

  def movement_stages
    activity_ids = params[:activity_ids]
    query = Activity.where("ActivityID in (?)", activity_ids).count(:group => "status")

    result = {}
    query.each_key do |key|
      result[Activity.statuses[key]] = query[key]
    end

    respond_with result do |format|
      format.json {
        render json: result
      }
    end
  end

  def create
    @stats = []
    params[:statistics].each do |stats|
      @movement = Activity.find(stats[:activity_id])
      stat = @movement.get_stat_for(Date.parse(stats[:period_begin]))
      stats[:updated_by] = current_user
      stat.attributes = stats.except(:id)
      stat.save
      if stat.errors.present?
        @stats << stat.attributes.merge({:errors => stat.errors.to_hash})
      end
    end

    respond_with @stats do |format|
      format.json {
        render json: @stats, :root => "statistics", status: :created
      }
    end
  end
end