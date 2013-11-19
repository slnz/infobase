namespace :infobase do
  task geocode: :environment do
    TargetArea.where("country = 'USA' or country = '' or country is NULL").where(longitude: nil).find_each(&:set_coordinates)
  end
end