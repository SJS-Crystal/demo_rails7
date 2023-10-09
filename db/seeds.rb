# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

unless Admin.find_by(email: 'admin@example.com')
  Admin.create!(
    email: 'admin@example.com',
    name: 'Admin',
    password: '123123',
    password_confirmation: '123123',
    confirmed_at: Time.zone.now
  )
  puts 'Admin created!'
else
  puts 'Admin already exists.'
end


currencies = ['USD', 'EUR', 'JPY', 'GBP', 'AUD']

currencies.each do |currency|
  Currency.create(name: currency)
end

puts 'Currency created!'
