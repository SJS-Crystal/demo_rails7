FactoryBot.define do
  factory :custom_field do
    name { Faker::Lorem.characters(number: 20) }
    value { Faker::Lorem.characters(number: 100) }
    custom_fieldable { create(:brand) }
  end
end
