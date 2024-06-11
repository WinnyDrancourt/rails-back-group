class Product < ApplicationRecord
  belongs_to :user
  has_one_attached :image

   # Validations
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 50, maximum: 400 }
  validates :price, numericality: { greater_than_or_equal_to: 10000, less_than_or_equal_to: 10000000 }
  validates :city, presence: true, length: { minimum: 3, maximum: 100 }
  validates :property_type, presence: true
  validates :category, presence: true
  validates :number_of_floors, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 50 }
  validates :energy_performance_diagnostic, presence: true
  validates :area, presence: true, numericality: { greater_than_or_equal_to: 9, less_than_or_equal_to: 1500 }
  validates :number_of_rooms, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 25 }

end
