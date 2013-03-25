class GcxSitesController < ApplicationController
  def new
    @gcx_site = GcxSite.new
    @activity = Activity.find(params[:activity_id])
  end

  def create
    @activity = Activity.find(params[:activity_id])
    @gcx_site = GcxApi::Site.new({sitetype: 'campus'}.merge(params[:gcx_site]))
    if @gcx_site.valid?

      @gcx_site.save

      # Add team members as an admins of this community
      users = []
      (@activity.team.team_members.collect(&:person).collect(&:user) + [current_user]).compact.uniq.each do |user|
        users << {relayGuid: user.globallyUniqueID, role: 'administrator'}
      end

      GcxApi::User.create(@gcx_site.name, users)

      @activity.update_attributes(gcx_site: @gcx_site.name)
      redirect_to new_gcx_site_path(activity_id: @activity.id)
    else
      render action: 'new', alert: @gcx_site.errors.full_messages.join('<br>')
    end
  end

end
