class Users::PasswordsController < Devise::PasswordsController # This controller is created to send correct message to the frontend
  respond_to :json
end