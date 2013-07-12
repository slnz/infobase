class Api::V1::PeopleController < Api::V1::BaseController
  def is_staff
    results = {}
    person_ids = params[:people].split(',')
    people = {}
    Person.where(personID: person_ids).collect {|p| people[p.id] = p}
    person_ids.each do |id|
      if p = people[id.to_i]
        results[id] = p.isStaff.present?
      else
        results[id] = nil
      end
    end
    result = {"people" => results}
    render json: result
  end
end
