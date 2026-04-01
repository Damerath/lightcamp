class CampTeamLinksController < ApplicationController
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access

  def create
    link = @camp_team.camp_team_links.new(camp_team_link_params.merge(position: next_position))

    if link.save
      redirect_to camp_team_page_path(@camp, @camp_team), notice: "Link wurde gespeichert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team), alert: link.errors.full_messages.to_sentence
    end
  end

  def update
    link = @camp_team.camp_team_links.find(params[:id])

    if link.update(camp_team_link_params)
      redirect_to camp_team_page_path(@camp, @camp_team), notice: "Link wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team), alert: link.errors.full_messages.to_sentence
    end
  end

  def destroy
    link = @camp_team.camp_team_links.find(params[:id])
    link.destroy

    redirect_to camp_team_page_path(@camp, @camp_team), notice: "Link wurde entfernt."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def camp_team_link_params
    params.require(:camp_team_link).permit(:title, :url)
  end

  def next_position
    (@camp_team.camp_team_links.maximum(:position) || -1) + 1
  end

  def require_team_access
    return if current_user&.admin?
    return if current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diese Teamseite."
  end
end
