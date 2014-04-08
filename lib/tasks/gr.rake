task :global => :environment do
  campus = Ministry.find_by(name: 'Campus Field Ministry')
  campus.async_push_to_global_registry

  regions = Region.all
  regions.map do |r|
    r.async_push_to_global_registry(campus.global_registry_id) unless t.global_registry_id
  end

  # create teams
  Team.all.each do |t|
    region = regions.detect {|r| r.abbrv = t.region}

    t.async_push_to_global_registry(region.global_registry_id)
  end

  # create target_areas
  TargetArea.all.each do |t|
    t.async_push_to_global_registry unless t.global_registry_id
  end

  # create activities
  Activity.all.each do |t|
    t.async_push_to_global_registry unless t.global_registry_id
  end

  # create statistics
  Statistic.all.each do |t|
    t.async_push_to_global_registry unless t.global_registry_id
  end
end

#SpApplication.accepted.find_each do |a|
# Person.find_each do |p|
#   #Person.where(personID: 111308).each do |p|
#   #p = a.person
#   gender = [1,0,'1','0'].include?(p.gender) ? (p.gender.to_i == 1 ? 'male' : 'female') : nil
#   isSecure = 0 if p.isSecure == 'F'
#   isSecure = 1 if p.isSecure == 'T'
#   isSecure ||= p.isSecure.to_i
#   person_hash = {entity: {
#       person:
#           {
#               first_name: p.firstName,
#               last_name: p.lastName,
#               middle_name: p.middleName,
#               preferred_name: p.preferredName,
#               gender: gender,
#               region: p.region,
#               work_in_us: p.workInUS,
#               us_citizen: p.usCitizen,
#               citizenship: p.citizenship,
#               is_staff: p.isStaff,
#               title: p.title,
#               campus: p.campus,
#               university_state: p.universityState,
#               year_in_school: p.yearInSchool,
#               major: p.major,
#               greek_affiliation: p.greekAffiliation,
#               marital_status: p.maritalStatus,
#               birth_date: p.birth_date,
#               date_became_christian: p.date_became_christian,
#               graduation_date: p.graduation_date,
#               is_secure: isSecure,
#               ministry: p.ministry,
#               strategy: p.strategy,
#               account_number: p.accountNo
#           }
#   }}
#
#   person_hash.select! { |_,v| v.present? }
#
#   if p.sp_applications.accepted.present?
#     person_hash[:person][:summer_project_application] = []
#     p.sp_applications.accepted.each do |a|
#       if a.project
#         person_hash[:person][:summer_project_application] << {
#             project: a.project.global_registry_id,
#             year: a.year,
#             status: a.status,
#             foreign_id: a.id
#         }
#       end
#     end
#   end
#
#   trackings = p.sitrack_trackings.where("asgTeam is not null")
#   if trackings.present?
#     person_hash[:person][:internship] = []
#     trackings.each do |tracking|
#       a = tracking.hr_si_application
#       team = if tracking.asgTeam.to_i > 0
#                tracking.team
#              else
#                Team.where(name: tracking.asgTeam).first
#              end
#       if team
#         person_hash[:person][:internship] << {
#             team: team.global_registry_id,
#             year: tracking.asgYear,
#             intern_type: tracking.internType,
#             foreign_id: a.id
#         }
#       end
#     end
#   end
#
#   # add email addresses
#   if p.email_addresses.present?
#     person_hash[:person][:email_address] ||= []
#     p.email_addresses.each do |e|
#       person_hash[:person][:email_address] << {
#           email: e.email,
#           primary: e.primary
#       }
#     end
#   end
#
#   # add phoen numbers
#   if p.phone_numbers.present?
#     person_hash[:person][:phone_number] ||= []
#     p.phone_numbers.each do |p|
#       person_hash[:person][:phone_number] << {
#           number: p.number,
#           primary: p.primary,
#           extension: p.extension,
#           location: p.location
#       }
#     end
#   end
#
#   a = p.addresses.where("addressType = 'current'").first
#   if a
#     person_hash[:person][:address] ||= []
#     address_hash = {city: a.city,
#                     state: a.state,
#                     postal_code: a.zip
#     }
#     address_hash[:country] = a.country if a.country.present?
#     address_hash[:dorm] = a.dorm if a.dorm.present?
#     address_hash[:room] = a.room if a.room.present?
#
#     address_hash[:line] = []
#     address_hash[:line] << a.address1 if a.address1.present?
#     address_hash[:line] << a.address2 if a.address2.present?
#     address_hash[:line] << a.address3 if a.address3.present?
#     address_hash[:line] << a.address4 if a.address4.present?
#
#     person_hash[:person][:address] << address_hash
#
#     # Phone numbers
#     if a.homePhone.present?
#       person_hash[:person][:phone_number] ||= []
#       person_hash[:person][:phone_number] << {
#           number: a.homePhone,
#           location: 'home'
#       }
#     end
#
#     if a.workPhone.present?
#       person_hash[:person][:phone_number] ||= []
#       person_hash[:person][:phone_number] << {
#           number: a.workPhone,
#           location: 'work'
#       }
#     end
#
#     if a.cellPhone.present?
#       person_hash[:person][:phone_number] ||= []
#       person_hash[:person][:phone_number] << {
#           number: a.cellPhone,
#           location: 'mobile'
#       }
#     end
#
#     # Email address
#     if a.email.present?
#       person_hash[:person][:email_address] ||= []
#       person_hash[:person][:email_address] << {
#           email: a.email
#       }
#     end
#   end
#
#
#   json = person_hash.to_json
#
#   if p.global_registry_id
#     response = RestClient.put(entities_endpoint(p.global_registry_id), json, :content_type => :json)
#   else
#     response = RestClient.post(entities_endpoint, json, :content_type => :json)
#   end
#   p.update_column(:global_registry_id, Oj.load(response)['person']['id']) unless p.global_registry_id
# end

# create summer project entity type
# response = RestClient.post(entity_types_endpoint, {entity_type: {name: 'summer_project'}}.to_json, :content_type => :json)
# sp_entity_type_id = Oj.load(response)['entity_type']['id'].to_i
# response = RestClient.post(entity_types_endpoint, {entity_type: {name: 'summer_project_application'}}.to_json, :content_type => :json)
# sp_application_type_id = Oj.load(response)['entity_type']['id'].to_i
#
# SpProject.all.each do |p|
#   project_hash = {entity: {summer_project: {
#       name: p.name,
#       foreign_id: p.id
#   }}}
#
#   json = project_hash.to_json
#   if p.global_registry_id
#     response = RestClient.put(entities_endpoint(p.global_registry_id), json, :content_type => :json)
#   else
#     response = RestClient.post(entities_endpoint, json, :content_type => :json)
#   end
#   id = Oj.load(response)['entity']['id']
#   Rails.logger.debug(response)
#   p.update_column(:global_registry_id, id)
#
#   # Add enum value
#   json = {enum_value: {entity_type_id: sp_entity_type_id, entity_id: id}}
#   response = RestClient.post(enum_values_endpoint, json, :content_type => :json)
# end
#
# # create si entity type
# response = RestClient.post(entity_types_endpoint, {entity_type: {name: 'internship_location'}}.to_json, :content_type => :json)
# si_entity_type_id = Oj.load(response)['entity_type']['id'].to_i
# response = RestClient.post(entity_types_endpoint, {entity_type: {name: 'internship'}}.to_json, :content_type => :json)
# si_application_type_id = Oj.load(response)['entity_type']['id'].to_i
#
# HrSiProject.all.each do |p|
#   project_hash = {entity: {internship_location: {
#       name: p.name,
#       partnership_region: p.partnershipRegion,
#       city: p.city,
#       country: p.country,
#       secure: p.secure,
#       foreign_id: p.id
#   }}}
#
#
#   json = project_hash.to_json
#   if p.global_registry_id
#     response = RestClient.put(entities_endpoint(p.global_registry_id), json, :content_type => :json)
#   else
#     response = RestClient.post(entities_endpoint, json, :content_type => :json)
#   end
#   id = Oj.load(response)['entity']['id']
#   Rails.logger.debug(response)
#   p.update_column(:global_registry_id, id)
#
#   # Add enum value
#   json = {enum_value: {entity_type_id: si_entity_type_id, entity_id: id}}
#   response = RestClient.post(enum_values_endpoint, json, :content_type => :json)
# end