require 'rails_helper'
require 'faker'

RSpec.describe User, type: :model do
  # Owner
  it "sets default owner to false on new records" do
    user = User.new
    expect(user.owner).to eq(false)
  end

  it "updates owner status based on products existence" do
    user = User.create!(email: Faker::Internet.email, password: "password")
    product = Product.create!(
      property_type: [ 'appartement', 'maison' ].sample,
      category: [ 'neuf', 'ancien', 'projet de construction' ].sample,
      city: Faker::Address.city[0...100],
      title: Faker::Lorem.characters(number: rand(5..50)),
      price: Faker::Commerce.price(range: 10000..10000000),
      description: Faker::Lorem.characters(number: rand(50..400)),
      user_id: user.id,
      pool: [ true, false ].sample,
      balcony: [ true, false ].sample,
      parking: [ true, false ].sample,
      garage: [ true, false ].sample,
      cellar: [ true, false ].sample,
      number_of_floors: rand(0..50),
      elevator: [ true, false ].sample,
      disabled_access: [ true, false ].sample,
      energy_performance_diagnostic: [ 'A', 'B', 'C', 'D', 'E', 'F', 'G' ].sample,
      area: Faker::Number.between(from: 9, to: 1500),
      number_of_rooms: rand(1..25),
      furnished: [ true, false ].sample,
      terrace: [ true, false ].sample,
      garden: [ true, false ].sample,
      basement: [ true, false ].sample,
      caretaker: [ true, false ].sample
    )
    user.update_owner_status
    expect(user.owner).to eq(true)
    product.destroy
    user.update_owner_status
    expect(user.owner).to eq(false)
  end

  it "destroys associated products when user is destroyed" do
    user = User.create!(email: Faker::Internet.email, password: "password")
    product = Product.create!(
      property_type: [ 'appartement', 'maison' ].sample,
      category: [ 'neuf', 'ancien', 'projet de construction' ].sample,
      city: Faker::Address.city[0...100],
      title: Faker::Lorem.characters(number: rand(5..50)),
      price: Faker::Commerce.price(range: 10000..10000000),
      description: Faker::Lorem.characters(number: rand(50..400)),
      user_id: user.id,
      pool: [ true, false ].sample,
      balcony: [ true, false ].sample,
      parking: [ true, false ].sample,
      garage: [ true, false ].sample,
      cellar: [ true, false ].sample,
      number_of_floors: rand(0..50),
      elevator: [ true, false ].sample,
      disabled_access: [ true, false ].sample,
      energy_performance_diagnostic: [ 'A', 'B', 'C', 'D', 'E', 'F', 'G' ].sample,
      area: Faker::Number.between(from: 9, to: 1500),
      number_of_rooms: rand(1..25),
      furnished: [ true, false ].sample,
      terrace: [ true, false ].sample,
      garden: [ true, false ].sample,
      basement: [ true, false ].sample,
      caretaker: [ true, false ].sample
    )
    expect { user.destroy }.to change { Product.count }.by(-1)
  end
end
