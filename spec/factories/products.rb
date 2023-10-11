FactoryBot.define do
  factory :product, class: 'Product' do
    name { "MyString" }
    status { 1 }
    price { 1.5 }
    association :brand, factory: :brand
    association :admin, factory: :admin
    stock { 10 }
    currency { Faker::Currency.code }
  end
end
