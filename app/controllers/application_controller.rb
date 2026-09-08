class ApplicationController < ActionController::Base
  before_action :basic_auth, if: -> { Rails.env.production? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :load_notification_deliveries, if: :user_signed_in?
  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(
        username.to_s,
        ENV.fetch("BASIC_AUTH_USER", "")
      ) &&
        ActiveSupport::SecurityUtils.secure_compare(
          password.to_s,
          ENV.fetch("BASIC_AUTH_PASSWORD", "")
        )
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  def require_complete_profile
    unless current_user.profile_complete?
      redirect_to profile_path, alert: "Bitte vervollständige zuerst dein Profil."
    end
  end

  def load_notification_deliveries
    @notification_deliveries = current_user.notification_deliveries.in_app_visible.limit(12)
    @unread_notification_count = @notification_deliveries.count(&:unread?)
  end
end
