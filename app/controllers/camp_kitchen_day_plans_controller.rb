class CampKitchenDayPlansController < ApplicationController
  include CampTeamAccess
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access

  def update
    kitchen_day_plan = @camp_team.camp_kitchen_day_plans.find(params[:id])

    if kitchen_day_plan.update(camp_kitchen_day_plan_params)
      redirect_to team_page_path(@camp, @camp_team, section: "kitchen_plan"), notice: "Küchenplan wurde aktualisiert."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "kitchen_plan"), alert: kitchen_day_plan.errors.full_messages.to_sentence
    end
  end

  private

  def camp_kitchen_day_plan_params
    params.require(:camp_kitchen_day_plan).permit(:breakfast, :lunch, :dinner, :snack)
  end
end
