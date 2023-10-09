FactoryBot.define do
  factory :client do
    username { Faker::Internet.unique.username }
    password { 'password' }
    name { Faker::Name.name }
    payout_rate { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    balance { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    association :admin, factory: :admin
  end
end
