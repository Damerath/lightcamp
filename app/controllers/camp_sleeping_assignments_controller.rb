class CampSleepingAssignmentsController < ApplicationController
  include CampTeamAccess
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_freizeitleiter_access

  def update
    application = @camp.assigned_camp_applications.find(params[:id])

    if application.update(camp_sleeping_assignment_params)
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Schlafplatz wurde aktualisiert."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), alert: application.errors.full_messages.to_sentence
    end
  end

  private

  def camp_sleeping_assignment_params
    params.require(:camp_application).permit(:camp_sleeping_place_id)
  end
end
