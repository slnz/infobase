class Api::V1::PeopleController < Api::V1::BaseController

  def is_staff
    results = {}
    person_ids = params[:people].split(',')
    people = {}
    Person.where(personID: person_ids).collect {|p| people[p.id] = p}
    person_ids.each do |id|
      if p = people[id.to_i]
        results[id] = p.isStaff?
      else
        results[id] = nil
      end
    end

    render json: {people: results}
  end
end
