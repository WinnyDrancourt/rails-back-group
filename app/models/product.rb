class Product < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  after_create :update_user_owner_status
  after_destroy :update_user_owner_status
  private

  def update_user_owner_status
    user.update_owner_status
  end
end
