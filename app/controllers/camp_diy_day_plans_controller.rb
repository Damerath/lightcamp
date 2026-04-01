class CampDiyDayPlansController < ApplicationController
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access

  def update
    diy_day_plan = @camp_team.camp_diy_day_plans.find(params[:id])

    if diy_day_plan.update(camp_diy_day_plan_params)
      redirect_to camp_team_page_path(@camp, @camp_team, section: "diy_plan"), notice: "DIY-Plan wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "diy_plan"), alert: diy_day_plan.errors.full_messages.to_sentence
    end
  end

  def apply_general_offer_to_all
    diy_day_plan = @camp_team.camp_diy_day_plans.find(params[:id])
    value = params.dig(:camp_diy_day_plan, :general_offer).to_s

    @camp_team.camp_diy_day_plans.update_all(general_offer: value, updated_at: Time.current)
    redirect_to camp_team_page_path(@camp, @camp_team, section: "diy_plan"), notice: "Allgemeines Angebot wurde auf alle Tage übernommen."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def camp_diy_day_plan_params
    params.require(:camp_diy_day_plan).permit(:general_offer, :daily_special)
  end

  def require_team_access
    return if current_user&.admin?
    return if current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diese Teamseite."
  end
end
