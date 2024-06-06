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

User.create(
  email: "admin@admin.fr",
  password: "admin123"
)

10.times do
User.create(
  email: Faker::Internet.email,
  password: "password"
)
puts "User created"
end

50.times do
Product.create(
  title: Faker::Commerce.product_name,
  price: Faker::Commerce.price,
  description: Faker::Lorem.paragraph,
  user_id: User.all.sample.id
)
puts "Product created"
end
