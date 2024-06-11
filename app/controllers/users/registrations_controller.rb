class Users::RegistrationsController < Devise::RegistrationsController
    respond_to :json

  def update_resource(resource, params) #this method is use to send the correct error message
    resource.update_with_password(params)
    unless resource.errors.empty?
      puts resource.errors.full_messages
    end
  end

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      if resource.errors.empty?
        register_success && return #if the resource is persisted and there are no errors
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity #If there are errors, it sends a JSON response with a key of "errors" and a value of an array of error messages. The status code of the response is 422 Unprocessable Entity.
      end
    else
      register_failed #If the resource is not persisted, it calls register_failed
    end
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
