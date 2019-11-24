class RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: [:create]

  respond_to :json

  def create
    super do
      if resource.errors.empty?
        resource.auth_token = SecureRandom.hex
        resource.save
      end
    end
  end
end
