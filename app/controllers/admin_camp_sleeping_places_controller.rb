class AdminCampSleepingPlacesController < ApplicationController
  before_action :require_admin
  before_action :set_camp
  before_action :set_camp_team

  def create
    place = @camp.camp_sleeping_places.new(camp_sleeping_place_params.merge(position: next_position, custom: true))

    if place.save
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Schlafmöglichkeit wurde hinzugefügt."
    else
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "room_plan"), alert: place.errors.full_messages.to_sentence
    end
  end

  def update
    place = @camp.camp_sleeping_places.find(params[:id])

    if place.update(camp_sleeping_place_params)
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Schlafmöglichkeit wurde aktualisiert."
    else
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "room_plan"), alert: place.errors.full_messages.to_sentence
    end
  end

  def destroy
    place = @camp.camp_sleeping_places.find(params[:id])

    if place.custom?
      place.destroy
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "room_plan"), notice: "Schlafmöglichkeit wurde entfernt."
    else
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "room_plan"), alert: "Standard-Zimmer können nicht gelöscht werden."
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

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
