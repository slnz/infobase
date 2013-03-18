class GcxSiteUsersController < ApplicationController
  def new
    @activity = Activity.find(params[:activity_id])
  end

  def create
  end

end
