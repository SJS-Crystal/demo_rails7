FactoryBot.define do
  factory :admin do
    email { Faker::Internet.email }
    password { 'password' }
    confirmed_at { Time.now }
    name { Faker::Lorem.characters(number: 10) }
  end
end
