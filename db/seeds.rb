# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
Faker::Config.locale = 'fr'

User.destroy_all
Product.destroy_all

User.create(
  email: "superadmin@yopmail.fr",
  password: "admin123"
)
puts "admin created mail sent"

5.times do
testuser = User.create(
  email: Faker::Internet.email,
  password: "password"
)
end

puts "Users created mail sent"
i = 0
50.times do
  i += 1
  Product.create!(
    property_type: ['appartement', 'maison'].sample,
    category: ['neuf', 'ancien', 'projet de construction'].sample,
    city: Faker::Address.city[0...100],
    title: "maison ou appartement #{i}",
    # title: Faker::Lorem.characters(number: rand(5..50)),
    price: Faker::Commerce.price(range: 10000..10000000),
    description: Faker::Lorem.characters(number: rand(50..400)),
    user_id: User.all.sample.id,
    pool: [true, false].sample,
    balcony: [true, false].sample,
    parking: [true, false].sample,
    garage: [true, false].sample,
    cellar: [true, false].sample,
    number_of_floors: rand(0..50),
    elevator: [true, false].sample,
    disabled_access: [true, false].sample,
    energy_performance_diagnostic: ['A', 'B', 'C', 'D', 'E', 'F', 'G'].sample,
    area: Faker::Number.between(from: 9, to: 1500),
    number_of_rooms: rand(1..25),
    furnished: [true, false].sample,
    terrace: [true, false].sample,
    garden: [true, false].sample,
    basement: [true, false].sample,
    caretaker: [true, false].sample
  )
end
puts "Products created"
