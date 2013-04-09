class GcxSitesController < ApplicationController
  def new
    @gcx_site = GcxApi::Site.new
    @activity = Activity.find(params[:activity_id])
  end

  def create
    @activity = Activity.find(params[:activity_id])
    parameters = params[:gcx_api_site].merge({privacy: 'public', theme: 'cru-reactiv', sitetype: 'campus'})

    @gcx_site = GcxApi::Site.new(parameters)

    if @gcx_site.valid?
      @gcx_site.create

      parameters = (@activity.team.team_members.collect(&:person).collect(&:user) + [current_user]).compact.uniq.collect do |user|
        {relayGuid: user.globallyUniqueID, role: 'administrator'}
      end

      GcxApi::User.create(@gcx_site.name, parameters)

      @activity.gcx_site = @gcx_site.name
      @activity.save(validate: false)

      redirect_to new_gcx_site_path(activity_id: @activity.id)
    else
      render action: 'new', alert: @gcx_site.errors.full_messages.join('<br>')
    end
  end

end
