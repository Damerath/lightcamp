class AdminCampApplicationsController < ApplicationController
  before_action :require_admin
  before_action :set_camp_application, only: :update_assignment

  def index
    @years = Year.order(name: :desc)
    @selected_year = selected_year
    @team_options = CampApplication::TEAM_OPTIONS

    @camp_applications = CampApplication
      .includes(:user, :year, :camps, :assigned_camp)
      .where(year: @selected_year)
      .order(created_at: :desc)
  end

  def update_assignment
    assigned_camp_id = assignment_params[:assigned_camp_id].presence
    @camp_application.assigned_camp_id = assigned_camp_id
    @camp_application.assigned_team = assignment_params[:assigned_team].presence

    if @camp_application.save
      redirect_to admin_camp_applications_path(year_id: @camp_application.year_id), notice: "Zuteilung wurde gespeichert."
    else
      redirect_to admin_camp_applications_path(year_id: @camp_application.year_id), alert: @camp_application.errors.full_messages.to_sentence
    end
  end

  private

  def set_camp_application
    @camp_application = CampApplication.includes(:camps, :year).find(params[:id])
  end

  def assignment_params
    params.require(:camp_application).permit(:assigned_camp_id, :assigned_team)
  end

  def selected_year
    if params[:year_id].present?
      Year.find_by(id: params[:year_id]) || Year.find_by(registration_open: true) || Year.order(name: :desc).first
    else
      Year.find_by(registration_open: true) || Year.order(name: :desc).first
    end
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Kein Zugriff"
    end
  end
end
