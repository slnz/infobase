class Api::V1::TeamsController < Api::V1::BaseController

  def index
    order = params[:order] || 'name'
    teams = params[:include_inactive] == 'true' ? Team.active : Team.all
    
    teams = TeamFilter.new(params[:filters]).filter(teams)

    render render_options(teams, order)
  end

  private

  def available_includes
    {people: [:phone_numbers, :email_addresses]}
  end

end
