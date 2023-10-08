FactoryBot.define do
  factory :brand do
    name { Faker::Lorem.characters(number: 20) }
    association :admin, factory: :admin
    status { 0 }
  end
end
