task :global => :environment do
  # create summer project entity type
  response = RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'summer_project'}}.to_json, :content_type => :json)
  sp_entity_type_id = Oj.load(response)['entity_type']['id'].to_i
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'name', field_type: 'string', parent_id: sp_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'foreign_id', field_type: 'integer', parent_id: sp_entity_type_id}}.to_json, :content_type => :json)
  response = RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'summer_project_application'}}.to_json, :content_type => :json)
  sp_application_type_id = Oj.load(response)['entity_type']['id'].to_i
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'project', field_type: 'enum', parent_id: sp_application_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'year', field_type: 'integer', parent_id: sp_application_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'status', field_type: 'string', parent_id: sp_application_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'foreign_id', field_type: 'integer', parent_id: sp_application_type_id}}.to_json, :content_type => :json)

  SpProject.where("global_registry_id is NULL").each do |p|
    project_hash = {entity: {summer_project: {
                       name: p.name,
                       foreign_id: p.id
                   }}}

    json = project_hash.to_json
    if p.global_registry_id
      response = RestClient.put("http://api.leadingwithinformation.com/entities/#{p.global_registry_id}?access_token=a", json, :content_type => :json)
    else
      response = RestClient.post('http://api.leadingwithinformation.com/entities?access_token=a', json, :content_type => :json)
    end
    id = Oj.load(response)['entity']['id']
    Rails.logger.debug(response)
    p.update_column(:global_registry_id, id)

    # Add enum value
    json = {enum_value: {entity_type_id: sp_entity_type_id, entity_id: id}}
    response = RestClient.post('http://api.leadingwithinformation.com/enum_values?access_token=a', json, :content_type => :json)
  end

  # create si entity type
  response = RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'internship_location'}}.to_json, :content_type => :json)
  si_entity_type_id = Oj.load(response)['entity_type']['id'].to_i
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'name', field_type: 'string', parent_id: si_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'partnership_region', field_type: 'string', parent_id: si_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'city', field_type: 'string', parent_id: si_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'country', field_type: 'string', parent_id: si_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'secure', field_type: 'boolean', parent_id: si_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'foreign_id', field_type: 'integer', parent_id: si_entity_type_id}}.to_json, :content_type => :json)

  response = RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'internship'}}.to_json, :content_type => :json)
  si_application_type_id = Oj.load(response)['entity_type']['id'].to_i
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'team', field_type: 'enum', parent_id: si_application_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'year', field_type: 'integer', parent_id: si_application_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'intern_type', field_type: 'string', parent_id: si_application_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'foreign_id', field_type: 'integer', parent_id: si_application_type_id}}.to_json, :content_type => :json)

  HrSiProject.where("global_registry_id is NULL").each do |p|
    project_hash = {entity: {internship_location: {
                       name: p.name,
                       partnership_region: p.partnershipRegion,
                       city: p.city,
                       country: p.country,
                       secure: p.secure,
                       foreign_id: p.id
                   }}}

    json = project_hash.to_json
    if p.global_registry_id
      response = RestClient.put("http://api.leadingwithinformation.com/entities/#{p.global_registry_id}?access_token=a", json, :content_type => :json)
    else
      response = RestClient.post('http://api.leadingwithinformation.com/entities?access_token=a', json, :content_type => :json)
    end
    id = Oj.load(response)['entity']['id']
    Rails.logger.debug(response)
    p.update_column(:global_registry_id, id)

    # Add enum value
    json = {enum_value: {entity_type_id: si_entity_type_id, entity_id: id}}
    response = RestClient.post('http://api.leadingwithinformation.com/enum_values?access_token=a', json, :content_type => :json)
  end

  # create teams
  response = RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'team'}}.to_json, :content_type => :json)
  team_entity_type_id = Oj.load(response)['entity_type']['id'].to_i
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'name', field_type: 'string', parent_id: team_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'foreign_id', field_type: 'integer', parent_id: team_entity_type_id}}.to_json, :content_type => :json)

  Team.where("global_registry_id is NULL").each do |p|
    project_hash = {entity: {team: {
                       name: p.name,
                       foreign_id: p.id
                   }}}


    json = project_hash.to_json
    if p.global_registry_id
      response = RestClient.put("http://api.leadingwithinformation.com/entities/#{p.global_registry_id}?access_token=a", json, :content_type => :json)
    else
      response = RestClient.post('http://api.leadingwithinformation.com/entities?access_token=a', json, :content_type => :json)
    end
    id = Oj.load(response)['entity']['id']
    Rails.logger.debug(response)
    p.update_column(:global_registry_id, id)

    # Add enum value
    json = {enum_value: {entity_type_id: team_entity_type_id, entity_id: id}}
    response = RestClient.post('http://api.leadingwithinformation.com/enum_values?access_token=a', json, :content_type => :json)
  end

  response = RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'person'}}.to_json, :content_type => :json)
  person_entity_type_id = Oj.load(response)['entity_type']['id'].to_i
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'first_name', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'last_name', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'middle_name', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'preferred_name', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'gender', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'region', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'work_in_us', field_type: 'boolean', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'us_citizen', field_type: 'boolean', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'citizenship', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'is_staff', field_type: 'boolean', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'title', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'campus', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'university_state', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'year_in_school', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'major', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'greek_affiliation', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'marital_status', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'birth_date', field_type: 'date', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'date_became_christian', field_type: 'date', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'graduation_date', field_type: 'date', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'is_secure', field_type: 'boolean', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'ministry', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'strategy', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'account_number', field_type: 'string', parent_id: person_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'foreign_id', field_type: 'integer', parent_id: person_entity_type_id}}.to_json, :content_type => :json)

  # Email
  response = RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'email_address'}}.to_json, :content_type => :json)
  email_address_entity_type_id = Oj.load(response)['entity_type']['id'].to_i
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'email', field_type: 'string', parent_id: email_address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'primary', field_type: 'boolean', parent_id: email_address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'foreign_id', field_type: 'integer', parent_id: email_address_entity_type_id}}.to_json, :content_type => :json)

  # phone number
  response = RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'phone_number'}}.to_json, :content_type => :json)
  phone_number_entity_type_id = Oj.load(response)['entity_type']['id'].to_i
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'number', field_type: 'string', parent_id: phone_number_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'extension', field_type: 'string', parent_id: phone_number_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'location', field_type: 'string', parent_id: phone_number_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'primary', field_type: 'boolean', parent_id: phone_number_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'foreign_id', field_type: 'integer', parent_id: phone_number_entity_type_id}}.to_json, :content_type => :json)

  # Address
  response = RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'address'}}.to_json, :content_type => :json)
  address_entity_type_id = Oj.load(response)['entity_type']['id'].to_i
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'city', field_type: 'string', parent_id: address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'state', field_type: 'string', parent_id: address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'postal_code', field_type: 'string', parent_id: address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'country', field_type: 'string', parent_id: address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'dorm', field_type: 'string', parent_id: address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'room', field_type: 'string', parent_id: address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'line1', field_type: 'string', parent_id: address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'line2', field_type: 'string', parent_id: address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'line3', field_type: 'string', parent_id: address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'line4', field_type: 'string', parent_id: address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'primary', field_type: 'boolean', parent_id: address_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'foreign_id', field_type: 'integer', parent_id: address_entity_type_id}}.to_json, :content_type => :json)

  # Team membership
  response = RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'team_membership'}}.to_json, :content_type => :json)
  team_membership_entity_type_id = Oj.load(response)['entity_type']['id'].to_i

  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'team', field_type: 'enum', parent_id: team_membership_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'is_leader', field_type: 'boolean', parent_id: team_membership_entity_type_id}}.to_json, :content_type => :json)
  RestClient.post('http://api.leadingwithinformation.com/entity_types?access_token=a', {entity_type: {name: 'foreign_id', field_type: 'integer', parent_id: team_membership_entity_type_id}}.to_json, :content_type => :json)

  Person.where("global_registry_id is NULL").find_each do |p|
    gender = [1,0,'1','0'].include?(p.gender) ? (p.gender.to_i == 1 ? 'male' : 'female') : nil
    isSecure = 0 if p.isSecure == 'F'
    isSecure = 1 if p.isSecure == 'T'
    isSecure ||= p.isSecure.to_i
    person_hash = {entity: {
                    person:
                    {
                      first_name: p.firstName,
                      last_name: p.lastName,
                      middle_name: p.middleName,
                      preferred_name: p.preferredName,
                      gender: gender,
                      region: p.region,
                      work_in_us: p.workInUS,
                      us_citizen: p.usCitizen,
                      citizenship: p.citizenship,
                      is_staff: p.isStaff,
                      title: p.title,
                      campus: p.campus,
                      university_state: p.universityState,
                      year_in_school: p.yearInSchool,
                      major: p.major,
                      greek_affiliation: p.greekAffiliation,
                      marital_status: p.maritalStatus,
                      birth_date: p.birth_date,
                      date_became_christian: p.date_became_christian,
                      graduation_date: p.graduation_date,
                      is_secure: isSecure,
                      ministry: p.ministry,
                      strategy: p.strategy,
                      account_number: p.accountNo,
                      foreign_id: p.id
                    }
                  }}

    person_hash.select! { |_,v| v.present? }

    if p.sp_applications.accepted.present?
      person_hash[:entity][:person][:summer_project_application] = []
      p.sp_applications.accepted.each do |a|
        if a.project
          person_hash[:entity][:person][:summer_project_application] << {
            project: a.project.global_registry_id,
            year: a.year,
            status: a.status,
            foreign_id: a.id
          }
        end
      end
    end

    trackings = p.sitrack_trackings.where("asgTeam is not null")
    if trackings.present?
      person_hash[:entity][:person][:internship] = []
      trackings.each do |tracking|
        a = tracking.hr_si_application
        team = if tracking.asgTeam.to_i > 0
                 tracking.team
               else
                 Team.where(name: tracking.asgTeam).first
               end
        if team
          person_hash[:entity][:person][:internship] << {
            team: team.global_registry_id,
            year: tracking.asgYear,
            intern_type: tracking.internType,
            foreign_id: a.id
          }
        end
      end
    end

    # team assignments
    person_hash[:entity][:person][:team_membership] = []
    p.team_members.each do |team_membership|
      person_hash[:entity][:person][:team_membership] << {
        team: team_membership.team.global_registry_id,
        is_leader: team_membership.is_leader,
        foreign_id: team_membership.id
      }
    end

    # add email addresses
    if p.email_addresses.present?
      person_hash[:entity][:person][:email_address] ||= []
      p.email_addresses.each do |e|
        person_hash[:entity][:person][:email_address] << {
          email: e.email,
          primary: e.primary,
          foreign_id: e.id
        }
      end
    end

    # add phone numbers
    if p.phone_numbers.present?
      person_hash[:entity][:person][:phone_number] ||= []
      p.phone_numbers.each do |pn|
        person_hash[:entity][:person][:phone_number] << {
          number: pn.number,
          primary: pn.primary,
          extension: pn.extension,
          location: pn.location,
          foreign_id: pn.id
        }
      end
    end

    a = p.addresses.where("addressType = 'current'").first
    if a
      address_hash = {city: a.city,
                      state: a.state,
                      postal_code: a.zip,
                      foreign_id: a.id}

      address_hash[:country] = a.country if a.country.present?
      address_hash[:dorm] = a.dorm if a.dorm.present?
      address_hash[:room] = a.room if a.room.present?

      address_hash[:line1] = a.address1 if a.address1.present?
      address_hash[:line2] = a.address2 if a.address2.present?
      address_hash[:line3] = a.address3 if a.address3.present?
      address_hash[:line4] = a.address4 if a.address4.present?

      person_hash[:entity][:person][:address] = address_hash
    end


    json = person_hash.to_json

    if p.global_registry_id
      response = RestClient.put("http://api.leadingwithinformation.com/entities/#{p.global_registry_id}?access_token=a", json, :content_type => :json)
    else
      response = RestClient.post('http://api.leadingwithinformation.com/entities?access_token=a', json, :content_type => :json)
    end
    p.update_column(:global_registry_id, Oj.load(response)['entity']['id']) unless p.global_registry_id
  end; nil
end


