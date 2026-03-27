class AdminCampApplicationsController < ApplicationController
  before_action :require_admin
  before_action :set_camp_application, only: :update_assignment

  def index
    @years = Year.order(name: :desc)
    @selected_year = selected_year

    @camp_applications = CampApplication
      .includes(:user, :year, :camps, :assigned_camp, :assigned_camp_team)
      .where(year: @selected_year)
      .order(created_at: :desc)
  end

  def update_assignment
    assigned_camp_team_id = assignment_params[:assigned_camp_team_id].presence
    @camp_application.assigned_camp_team_id = assigned_camp_team_id
    @camp_application.assigned_as_responsible = assignment_params[:assigned_as_responsible] == "1"

    if @camp_application.save
      redirect_to assignment_return_path, notice: "Zuteilung wurde gespeichert."
    else
      redirect_to assignment_return_path, alert: @camp_application.errors.full_messages.to_sentence
    end
  end

  private

  def set_camp_application
    @camp_application = CampApplication.includes(:camps, :year).find(params[:id])
  end

  def assignment_params
    params.require(:camp_application).permit(:assigned_camp_team_id, :assigned_as_responsible)
  end

  def assignment_return_path
    return_to = params[:return_to].to_s

    if return_to.start_with?("/") && !return_to.start_with?("//")
      return_to
    else
      admin_camp_applications_path(year_id: @camp_application.year_id)
    end
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
