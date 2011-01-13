class TeamsController < ApplicationController
  before_filter :setup
  
  def show
    @team = Team.find(params[:id])
  end

  private
    def setup
      @menubar = "ministry"
      @submenu = "teams"
      @title = "Infobase - Team Home"
    end
end
