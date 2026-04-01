class CampTeamShoppingItemsController < ApplicationController
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access

  def create
    shopping_item = @camp_team.camp_team_shopping_items.new(camp_team_shopping_item_params.merge(position: next_position))

    if shopping_item.save
      redirect_to camp_team_page_path(@camp, @camp_team, section: "shopping"), notice: "Einkaufslisten-Eintrag wurde gespeichert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "shopping"), alert: shopping_item.errors.full_messages.to_sentence
    end
  end

  def update
    shopping_item = @camp_team.camp_team_shopping_items.find(params[:id])

    if shopping_item.update(camp_team_shopping_item_params)
      redirect_to camp_team_page_path(@camp, @camp_team, section: "shopping"), notice: "Einkaufslisten-Eintrag wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "shopping"), alert: shopping_item.errors.full_messages.to_sentence
    end
  end

  def destroy
    shopping_item = @camp_team.camp_team_shopping_items.find(params[:id])
    shopping_item.destroy

    redirect_to camp_team_page_path(@camp, @camp_team, section: "shopping"), notice: "Einkaufslisten-Eintrag wurde entfernt."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def camp_team_shopping_item_params
    params.require(:camp_team_shopping_item).permit(:name, :quantity, :notes, :purchased)
  end

  def next_position
    (@camp_team.camp_team_shopping_items.maximum(:position) || -1) + 1
  end

  def require_team_access
    return if current_user&.admin?
    return if current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diese Teamseite."
  end
end
