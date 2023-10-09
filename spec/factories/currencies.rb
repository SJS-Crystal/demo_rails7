FactoryBot.define do
  factory :currency do
    name { Faker::Lorem.characters(number: 3) }
  end
end
