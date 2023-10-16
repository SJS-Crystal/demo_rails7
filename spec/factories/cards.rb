FactoryBot.define do
  factory :card do
    association :client
    association :product

    activation_code { SecureRandom.hex(10) }
    purchase_pin { SecureRandom.hex(10) }
    price { Faker::Commerce.price }
    usd_price { Faker::Commerce.price }
    currency { Faker::Currency.code }

    trait :pending_approval do
      status { 'pending_approval' }
    end

    trait :issued do
      status { 'issued' }
    end

    trait :active do
      status { 'active' }
    end

    trait :rejected do
      status { 'rejected' }
    end

    after(:build) do |card|
      card.price ||= card.product.price
      card.usd_price ||= card.product.usd_price
      card.currency ||= card.product_currency
    end
  end
end
