class PasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token, only: [:update]

  respond_to :json

  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])
    if resource.errors.empty?
        respond_to do |format|
            format.json { render(json: resource, status: 200) }
            format.html { redirect_to after_resetting_password_path_for(resource) }
        end
    else
        respond_with resource
    end
  end
end
