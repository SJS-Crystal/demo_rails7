class Admin::RegistrationsController < Devise::RegistrationsController
  layout 'admin/devise'

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_up_path_for(_resource)
    new_session_path(resource_name)
  end

  def after_inactive_sign_up_path_for(_resource)
    new_session_path(resource_name)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
