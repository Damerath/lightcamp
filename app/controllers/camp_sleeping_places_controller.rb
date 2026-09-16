class CampSleepingPlacesController < ApplicationController
  include CampTeamAccess
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_freizeitleiter_access

  def create
    place = @camp.camp_sleeping_places.new(camp_sleeping_place_params.merge(position: next_position, custom: true))

    if place.save
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Schlafmöglichkeit wurde hinzugefügt."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), alert: place.errors.full_messages.to_sentence
    end
  end

  def update
    place = @camp.camp_sleeping_places.find(params[:id])

    if place.update(camp_sleeping_place_params)
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Schlafmöglichkeit wurde aktualisiert."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), alert: place.errors.full_messages.to_sentence
    end
  end

  def destroy
    place = @camp.camp_sleeping_places.find(params[:id])

    if place.custom?
      place.destroy
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Schlafmöglichkeit wurde entfernt."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "room_plan"), alert: "Standard-Zimmer können nicht gelöscht werden."
    end
  end

  private

  def camp_sleeping_place_params
    params.require(:camp_sleeping_place).permit(:name, :capacity, :details)
  end

  def next_position
    (@camp.camp_sleeping_places.maximum(:position) || -1) + 1
  end
end
