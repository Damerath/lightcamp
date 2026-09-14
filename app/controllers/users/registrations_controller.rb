class Users::RegistrationsController < Devise::RegistrationsController
  before_action :verify_human_registration, only: :create

  private

  def verify_human_registration
    return reject_registration! if params[:website].present?

    verification = TurnstileVerification.new(
      token: params["cf-turnstile-response"],
      remote_ip: request.remote_ip
    ).verify

    return if verification.success?

    Rails.logger.warn("Turnstile rejected registration: #{verification.error_code}")
    reject_registration!
  end

  def reject_registration!
    build_resource(sign_up_params)
    clean_up_passwords(resource)
    flash.now[:alert] = "Die Sicherheitsprüfung ist fehlgeschlagen. Bitte versuche es erneut."
    render :new, status: :unprocessable_entity
  end
end
