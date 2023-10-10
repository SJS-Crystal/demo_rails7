FactoryBot.define do
  factory :product, class: 'Product' do
    name { "MyString" }
    status { 1 }
    price { 1.5 }
    association :currency, factory: :currency
    association :brand, factory: :brand
    association :admin, factory: :admin
    stock { 10 }
  end
end
