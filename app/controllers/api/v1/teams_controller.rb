class Api::V1::TeamsController < Api::V1::BaseController

  def index
    order = params[:order] || 'name'
    teams = params[:include_inactive] == 'true' ? Team.all : Team.active

    teams = TeamFilter.new(params[:filters]).filter(teams).uniq

    render render_options(teams, order)
  end

  def search
    index
  end

  def show
    team = Team.find(params[:id])

    render render_options(team)
  end

  private

  def available_includes
    [{people: [:phone_numbers, :email_addresses]}, {activities: :target_area}]
  end

end
