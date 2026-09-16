class CampRoomPeopleController < ApplicationController
  include CampTeamAccess
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_freizeitleiter_access

  def create
    person = @camp.camp_room_people.new(camp_room_person_params)

    if person.save
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Weitere Person wurde hinzugefügt."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), alert: person.errors.full_messages.to_sentence
    end
  end

  def update
    person = @camp.camp_room_people.find(params[:id])

    if person.update(camp_room_person_params)
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Weitere Person wurde aktualisiert."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), alert: person.errors.full_messages.to_sentence
    end
  end

  def destroy
    person = @camp.camp_room_people.find(params[:id])
    person.destroy

    redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Weitere Person wurde entfernt."
  end

  private

  def camp_room_person_params
    params.require(:camp_room_person).permit(:name, :kind, :notes, :camp_sleeping_place_id, :related_camp_application_id)
  end
end
