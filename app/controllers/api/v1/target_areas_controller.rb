class Api::V1::TargetAreasController < Api::V1::BaseController

  def index
    target_areas = TargetAreaFilter.new(params[:filters]).filter(TargetArea.all)

    render render_options(target_areas)
  end

  private

  def available_includes
    [:teams]
  end
end
