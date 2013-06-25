class Api::V1::PeopleController < Api::V1::BaseController
  def is_staff
    results = {}
    person_ids = params[:people]
    person_ids.each do |id|
      begin
        p = Person.find(id)
        results[id] = p && p.isStaff.present?
      rescue
        results[id] = nil
      end
    end
    result = {"people" => results}
    respond_with result
  end
end