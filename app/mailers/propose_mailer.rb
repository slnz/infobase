class ProposeMailer < ActionMailer::Base
  default :from => "help@cru.org",
          :to => "todd.gross@cojourners.com"
  
  def propose_location(location, person, host)
    @location = location
    @person = person
    @host = host
    @request_params = "?"  # For link back to Infobase to approve new team
    attributes = @location.attributes
    attributes.each_key do |attribute|
      if !attributes[attribute].blank?
        @request_params += "target_area[" + URI::escape(attribute.to_s) + "]=" + URI::escape(attributes[attribute].to_s) + "&"
      end
    end
    @request_params.chop!  # Last charachter will be either '?' or '&'
    mail(:subject => "New Location Proposal")
  end

  def propose_team(team, person, host)
    @team = team
    @person = person
    @host = host
    @request_params = "?"  # For link back to Infobase to approve new team
    attributes = @team.attributes
    attributes.each_key do |attribute|
      if !attributes[attribute].blank?
        @request_params += "team[" + URI::escape(attribute.to_s) + "]=" + URI::escape(attributes[attribute].to_s) + "&"
      end
    end
    @request_params.chop!  # Last charachter will be either '?' or '&'
    mail(:subject => "New Team Proposal")
  end
end
