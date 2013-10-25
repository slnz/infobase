FactoryGirl.define do
  factory :activity do
    status "LA"
    periodBegin 1.year.ago
    strategy 'FS'
    association :target_area
    association :team
  end
end
