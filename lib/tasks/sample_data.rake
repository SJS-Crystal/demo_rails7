namespace :db do
  desc "Fill database with sample data"
  task generate_sample_data: :environment do
    require 'faker'

    # Admins
    Admin.create!(
      email: 'admin@example.com',
      name: 'Admin',
      password: '123123',
      password_confirmation: '123123',
      confirmed_at: Time.zone.now
    )
    admins = []
    10.times do
      admins << Admin.new(
        email: Faker::Internet.unique.email,
        name: Faker::Name.name.first(10),
        password: '123123',
        confirmed_at: Time.now.utc
      )
    end
    Admin.import! admins, validate: false
    puts "Admins created!"

    # Currencies
    currencies = []
    20.times do
      currencies << Currency.new(name: Faker::Currency.unique.code)
    end
    Currency.import! currencies, validate: false
    puts "Currencies created!"

    # Brands
    brands = []
    Admin.all.each do |admin|
      5.times do
        brands << Brand.new(
          name: Faker::Company.name.first(10),
          admin_id: admin.id,
          status: [0,1].sample
        )
      end
    end
    Brand.import! brands, validate: false
    puts "Brands created!"

    # Products
    products = []
    Brand.all.each do |brand|
      20.times do
        products << Product.new(
          name: Faker::Commerce.product_name.first(10),
          brand_id: brand.id,
          admin_id: brand.admin_id,
          status: [0,1].sample,
          price: Faker::Commerce.price,
          usd_price: Faker::Commerce.price,
          stock: rand(100..1000),
          currency: Currency.order('RANDOM()').first.name
        )
      end
    end
    Product.import! products, validate: false
    puts "Products created!"

    # Clients
    clients = []
    Admin.all.each do |admin|
      20.times do
        clients << Client.new(
          username: Faker::Internet.unique.username.first(10),
          name: Faker::Name.name.first(10),
          password: 'password',
          admin_id: admin.id,
          payout_rate: Faker::Number.decimal(l_digits: 2),
          balance: Faker::Number.decimal(l_digits: 3)
        )
      end
    end
    Client.import! clients, validate: false
    puts "Clients created!"

    # Custom Fields for Products and Brands
    custom_fields = []
    [Product, Brand].each do |resource_type|
      resource_type.find_each do |resource|
        1.upto(5) do |i|
          custom_fields << CustomField.new(
            name: "Field#{i}",
            value: Faker::Lorem.word,
            custom_fieldable_type: resource_type.to_s,
            custom_fieldable_id: resource.id
          )
        end
      end
    end
    CustomField.import! custom_fields, validate: false
    puts "Custom fields created!"

    # Cards
    cards = []
    Client.all.each do |client|
      Product.where(admin_id: client.admin_id).each do |product|
        rand(1..5).times do
          cards << Card.new(
            product_id: product.id,
            client_id: client.id,
            activation_code: Faker::Number.unique.hexadecimal(digits: 10),
            status: [0,1,2,3,4].sample,
            purchase_pin: Faker::Number.unique.hexadecimal(digits: 10),
            price: product.price,
            usd_price: product.usd_price,
            currency: product.currency,
            admin_id: product.admin_id,
            created_at: Faker::Date.between(from: 1.year.ago, to: Time.zone.now)
          )
        end
      end
    end
    Card.import! cards, validate: false
    puts "Cards created!"

    puts "Sample data generated successfully!"
  end
end
