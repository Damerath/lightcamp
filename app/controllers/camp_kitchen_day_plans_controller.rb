class CampKitchenDayPlansController < ApplicationController
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access

  def update
    kitchen_day_plan = @camp_team.camp_kitchen_day_plans.find(params[:id])

    if kitchen_day_plan.update(camp_kitchen_day_plan_params)
      redirect_to camp_team_page_path(@camp, @camp_team, section: "kitchen_plan"), notice: "Küchenplan wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "kitchen_plan"), alert: kitchen_day_plan.errors.full_messages.to_sentence
    end
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def camp_kitchen_day_plan_params
    params.require(:camp_kitchen_day_plan).permit(:breakfast, :lunch, :dinner, :snack)
  end

  def require_team_access
    return if current_user&.admin?
    return if current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diese Teamseite."
  end
end
