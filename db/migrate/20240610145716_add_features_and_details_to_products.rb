class AddFeaturesAndDetailsToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :property_type, :string
    add_column :products, :category, :string
    add_column :products, :pool, :boolean
    add_column :products, :balcony, :boolean
    add_column :products, :parking, :boolean
    add_column :products, :garage, :boolean
    add_column :products, :cellar, :boolean
    add_column :products, :number_of_floors, :integer
    add_column :products, :elevator, :boolean
    add_column :products, :disabled_access, :boolean
    add_column :products, :energy_performance_diagnostic, :string
    add_column :products, :area, :decimal
    add_column :products, :number_of_rooms, :integer
    add_column :products, :furnished, :boolean
    add_column :products, :terrace, :boolean
    add_column :products, :garden, :boolean
    add_column :products, :basement, :boolean
    add_column :products, :caretaker, :boolean
    add_column :products, :city, :string
  end
end
