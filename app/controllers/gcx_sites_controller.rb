class GcxSitesController < ApplicationController
  def new
    @gcx_site = GcxSite.new
    @activity = Activity.find(params[:activity_id])
  end

  def create
    @activity = Activity.find(params[:activity_id])
    @gcx_site = GcxSite.new(params[:gcx_site])
    if @gcx_site.valid?
      service_url = Rails.configuration.gcx_url + "/wp-gcx/create-community.php"
      ticket = get_key_service_ticket(service_url)

      parameters = {name: @gcx_site.name, privacy: 'public', title: @gcx_site.title, theme: 'amped', sitetype: 'campus'}.to_json

      res = RestClient::Request.execute(:method => :post, :url => service_url + '?ticket=' + ticket, :payload => parameters, :timeout => -1) { |response, request, result, &block|
                                                                                                                                               ap request
                                                                                                                                               ap result.inspect
                                                                                                                                                # check for error response
                                                                                                                                               if [301, 302, 307].include? response.code
                                                                                                                                                 response.follow_redirection(request, result, &block)
                                                                                                                                               elsif response.code.to_i != 200
                                                                                                                                                 raise response.headers.inspect + response.inspect
                                                                                                                                               end
                                                                                                                                               response.to_str
      }
      community = JSON.parse(res)
      if community['errors']
        raise community.inspect
      else

        # Add current user as an admin of this community
        service_url = Rails.configuration.gcx_url + "/#{@gcx_site.name}/wp-gcx/add-users.php"
        ticket = get_key_service_ticket(service_url)

        (@activity.team.team_members.collect(&:person).collect(&:user) + [current_user]).compact.uniq.each do |user|
          parameters = [{relayGuid: user.globallyUniqueID, role: 'administrator'}].to_json
          res = RestClient::Request.execute(:method => :post, :url => service_url + '?ticket=' + ticket, :payload => parameters, :timeout => -1) { |response, request, result, &block|
                                                                                                                                                                Rails.logger.ap request
                                                                                                                                                                # check for error response
                                                                                                                                                                if response.code.to_i == 400
                                                                                                                                                                  raise response.inspect
                                                                                                                                                                end
                                                                                                                                                                if response.code.to_i != 200
                                                                                                                                                                  raise result.inspect
                                                                                                                                                                end
                                                                                                                                                                response.to_str
          }
        end

        @activity.update_attributes(gcx_site: params[:gcx_site][:name])
        redirect_to new_gcx_site_path(activity_id: @activity.id)
      end
    else
      render action: 'new', alert: @gcx_site.errors.full_messages.join('<br>')
    end
  end

end
