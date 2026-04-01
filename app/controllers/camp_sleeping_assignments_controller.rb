class CampSleepingAssignmentsController < ApplicationController
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_freizeitleiter_access

  def update
    application = @camp.assigned_camp_applications.find(params[:id])

    if application.update(camp_sleeping_assignment_params)
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Schlafplatz wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), alert: application.errors.full_messages.to_sentence
    end
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
  end

  def camp_sleeping_assignment_params
    params.require(:camp_application).permit(:camp_sleeping_place_id)
  end

  def require_freizeitleiter_access
    return if current_user&.admin?
    return if @camp_team.name == "Freizeitleiter" && current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diesen Bereich."
  end
end
