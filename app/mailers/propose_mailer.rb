class ProposeMailer < ActionMailer::Base
  default :from => "help@campuscrusadeforchrist.com",
          :to => "justin.sabelko@uscm.org"  #TODO: change
  
  def propose_location(location, person, host)
    @location = location
    @person = person
    @host = host
    @request_params = "?"  # For link back to Infobase to approve new team
    attributes = @location.attributes
    attributes.each_key do |attribute|
      if !attributes[attribute].blank?
        @request_params += "target_area[" + attribute.to_s + "]=" + attributes[attribute].to_s + "&"
      end
    end
    @request_params.chop!  # Last charachter will be either '?' or '&'
    mail(:subject => "New Location Proposal")
  end
end
