class Api::V1::ActivitiesController < Api::V1::BaseController

  def index
    activities = ActivityFilter.new(params[:filters]).filter(Activity)

    render render_options(activities)
  end

  private

  def available_includes
    [:target_area]
  end
end
