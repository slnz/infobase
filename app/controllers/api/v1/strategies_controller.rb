class Api::V1::StrategiesController < Api::V1::BaseController

  def index
    strategies = Strategy.order(:name)

    render render_options(strategies)
  end

  private

end
