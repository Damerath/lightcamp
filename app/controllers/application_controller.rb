class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  def require_complete_profile
    unless current_user.profile_complete?
      redirect_to profile_path, alert: "Bitte vervollständige zuerst dein Profil."
    end
  end
end