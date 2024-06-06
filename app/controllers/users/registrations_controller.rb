class Users::RegistrationsController < Devise::RegistrationsController
    respond_to :json

    def recover_password
      user = User.find_by(email: params[:email])
  
      if user
        raw, enc = Devise.token_generator.generate(User, :reset_password_token)
        user.reset_password_token   = enc
        user.reset_password_sent_at = Time.now.utc
        user.save(validate: false)
        render json: { message: 'Reset password token generated', reset_password_token: raw }, status: :ok
      else
        render json: { error: 'Email not found' }, status: :not_found
      end
    end

    def reset_password
      user = User.with_reset_password_token(params[:reset_password_token])
  
      if user && user.reset_password_period_valid?
        user.password = params[:password]
        user.password_confirmation = params[:password_confirmation]
        if user.save
          render json: { message: 'Password reset successfully' }, status: :ok
        else
          render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Token invalid or expired' }, status: :unprocessable_entity
      end
    end

  private

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: {
      message: "Signed up successfully.",
      user: current_user
    }, status: :ok
  end

  def register_failed
    render json: { message: "Something went wrong" },
    status: :unprocessable_entity
  end


end
