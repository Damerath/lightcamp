class CampApplicationsController < ApplicationController
  before_action :require_complete_profile

  def new
    @camp_application = CampApplication.new
    @active_year = Year.find_by(registration_open: true)

    unless @active_year
      redirect_to root_path, alert: "Aktuell ist keine Camp-Anmeldung geöffnet."
    end

    @already_applied_camp_ids = current_user.camp_applications
      .where(year: @active_year)
      .joins(:camp_application_choices)
      .pluck("camp_application_choices.camp_id")
      .uniq
  end

  def create
    @active_year = Year.find_by(registration_open: true)

    unless @active_year
      redirect_to root_path, alert: "Aktuell ist keine Camp-Anmeldung geöffnet."
      return
    end

    @camp_application = current_user.camp_applications.new(camp_application_params)
    @camp_application.year = @active_year

    if @camp_application.save
      Array(params[:camp_application][:camp_ids]).reject(&:blank?).each do |camp_id|
        @camp_application.camp_application_choices.create!(camp_id: camp_id)
      end

      redirect_to root_path, notice: "Deine Camp-Anmeldung wurde gespeichert."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def camp_application_params
    params.require(:camp_application).permit(
      :commitment,
      :uncertain_until,
      :team_preference,
      :responsible,
      :health_restrictions,
      :health_restrictions_details,
      :motivation,
      :comment
    )
  end
end