class AdminCampsController < ApplicationController
  before_action :require_admin

def index
  @years = Year.includes(:camps).order(name: :desc)

  if params[:modal] == "edit_year"
    @year = Year.find_by(id: params[:year_id])
  end

  if params[:modal] == "edit_camp"
    @camp = Camp.find_by(id: params[:camp_id])
  end
end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Kein Zugriff"
    end
  end
end