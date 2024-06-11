class User < ApplicationRecord
  after_create :welcome_send

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end
  
  has_many :products, dependent: :destroy
  after_initialize :set_default_owner, if: :new_record?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
        :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  def set_default_owner
    self.owner ||= false
  end
  
  def update_owner_status
    self.update(owner: self.products.exists?)
  end
end
