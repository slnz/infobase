FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "foo#{n}@example.com"}
  end
end
