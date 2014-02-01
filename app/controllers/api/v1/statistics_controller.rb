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
    statistics = StatisticFilter.new(params[:filters])
                                .filter(Statistic.all)
                                .includes(activity: :target_area)

    if params[:filters] && params[:filters][:period_begin] && params[:filters][:period_end]
      statistics = case params[:collate_by]
                     when 'activity'
                       statistics.group('fk_Activity')
                     else
                       statistics.joins(activity: :target_area)
                                 .group('fk_targetAreaID')
                   end
    end

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
    begin_date = Date.parse(params[:begin_date]).beginning_of_week(:sunday)
    end_date = Date.parse(params[:end_date]).end_of_week(:sunday)
    activity_ids = params[:activity_ids]
    semester_needed = params[:semester]
    interval = params[:interval] if params.has_key?(:interval)
    interval ||= 1 # in weeks

    report = InfobaseReport.create_report_intervals(begin_date, end_date, activity_ids, semester_needed, interval)

    response = {}
    period_end_date = begin_date.end_of_week(:sunday) + (interval - 1).weeks # first interval includes 1st week by default, need to subtract a week
    temp_row = InfobaseReportRow.new(period_end_date.to_s)
    report.rows.each do |row|
      date = Date.parse(row.name)
      if date > period_end_date # Outside of interval. Add a plot point and start new interval
        response[period_end_date] = temp_row
        period_end_date = bump_period_end_date(period_end_date, interval, date, response)
        temp_row = row
        if report.rows.last == row # Last row as well.  Need to add to report.
          response[period_end_date] = temp_row
        end
      elsif report.rows.last == row # Last row.  Add 'em and report.
        temp_row = row + temp_row
        response[period_end_date] = temp_row
      else # Still within interval, just add records together.
        temp_row = row + temp_row
      end
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

  protected

  def bump_period_end_date(period_end_date, interval, date, response)
    result = period_end_date + interval.weeks
    while date > result do
      response[result.to_s] = InfobaseReportRow.new
      result = result + interval.weeks
    end
    result
  end
end