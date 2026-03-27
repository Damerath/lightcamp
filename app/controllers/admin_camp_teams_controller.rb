class AdminCampTeamsController < ApplicationController
  before_action :require_admin
  before_action :set_camp

  def index
    @year_camps = @camp.year.camps.order(:name)
    @camp_teams = @camp.camp_teams
      .includes(assigned_camp_applications: :user)
      .ordered

    if params[:modal] == "edit_team"
      @camp_team = @camp.camp_teams.find_by(id: params[:camp_team_id])
    end
  end

  def update
    @camp_team = @camp.camp_teams.find(params[:id])

    if @camp_team.update(camp_team_params)
      redirect_to admin_camp_teams_path(@camp), notice: "Team wurde aktualisiert."
    else
      redirect_to admin_camp_teams_path(@camp, modal: "edit_team", camp_team_id: @camp_team.id), alert: @camp_team.errors.full_messages.to_sentence
    end
  end

  private

  def set_camp
    @camp = Camp.includes(:year).find(params[:camp_id])
  end

  def camp_team_params
    params.require(:camp_team).permit(:name, :capacity, :male_slots, :female_slots, :responsible_slots, :position)
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Kein Zugriff"
    end
  end
end
