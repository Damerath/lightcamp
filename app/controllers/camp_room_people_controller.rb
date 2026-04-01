class CampRoomPeopleController < ApplicationController
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_freizeitleiter_access

  def create
    person = @camp.camp_room_people.new(camp_room_person_params)

    if person.save
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Weitere Person wurde hinzugefügt."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), alert: person.errors.full_messages.to_sentence
    end
  end

  def update
    person = @camp.camp_room_people.find(params[:id])

    if person.update(camp_room_person_params)
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Weitere Person wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), alert: person.errors.full_messages.to_sentence
    end
  end

  def destroy
    person = @camp.camp_room_people.find(params[:id])
    person.destroy

    redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Weitere Person wurde entfernt."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
  end

  def camp_room_person_params
    params.require(:camp_room_person).permit(:name, :kind, :notes, :camp_sleeping_place_id, :related_camp_application_id)
  end

  def require_freizeitleiter_access
    return if current_user&.admin?
    return if @camp_team.name == "Freizeitleiter" && current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diesen Bereich."
  end
end
