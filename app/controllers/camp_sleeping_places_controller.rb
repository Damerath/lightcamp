class CampSleepingPlacesController < ApplicationController
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_freizeitleiter_access

  def create
    place = @camp.camp_sleeping_places.new(camp_sleeping_place_params.merge(position: next_position, custom: true))

    if place.save
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Schlafmöglichkeit wurde hinzugefügt."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), alert: place.errors.full_messages.to_sentence
    end
  end

  def update
    place = @camp.camp_sleeping_places.find(params[:id])

    if place.update(camp_sleeping_place_params)
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Schlafmöglichkeit wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), alert: place.errors.full_messages.to_sentence
    end
  end

  def destroy
    place = @camp.camp_sleeping_places.find(params[:id])

    if place.custom?
      place.destroy
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Schlafmöglichkeit wurde entfernt."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), alert: "Standard-Zimmer können nicht gelöscht werden."
    end
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
  end

  def camp_sleeping_place_params
    params.require(:camp_sleeping_place).permit(:name, :capacity, :details)
  end

  def next_position
    (@camp.camp_sleeping_places.maximum(:position) || -1) + 1
  end

  def require_freizeitleiter_access
    return if current_user&.admin?
    return if @camp_team.name == "Freizeitleiter" && current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diesen Bereich."
  end
end
