class ProposeMailer < ActionMailer::Base
  default :from => "help@campuscrusadeforchrist.com",
          :to => "justin.sabelko@uscm.org"  #TODO: change
  
  def propose_location(location, person, host)
    @location = location
    @person = person
    @host = host
    @request_params = "?"
    attributes = @location.attributes
    attributes.each_key do |attribute|
      if !attributes[attribute].blank?
        @request_params += "target_area[" + attribute.to_s + "]=" + attributes[attribute].to_s + "&"
      end
    end
    @request_params.chop!
    mail(:subject => "New Team Proposal")
  end
end
