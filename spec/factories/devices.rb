FactoryBot.define do
  factory :device do
    device_id { SecureRandom.uuid }
    secret { SecureRandom.hex }
    association :client, factory: :client
  end
end
