require 'faker'

Admin.create!(
  email: 'admin@example.com',
  name: 'Admin',
  password: '123123',
  password_confirmation: '123123',
  confirmed_at: Time.zone.now
)
puts 'Admin created!'

currencies = []
20.times do
  currencies << Currency.new(name: Faker::Currency.unique.code)
end
Currency.import! currencies
puts 'Currencies created!'
