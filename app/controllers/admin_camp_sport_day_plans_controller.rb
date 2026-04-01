class AdminCampSportDayPlansController < ApplicationController
  before_action :require_admin
  before_action :set_camp
  before_action :set_camp_team

  def update
    sport_day_plan = @camp_team.camp_sport_day_plans.find(params[:id])

    if sport_day_plan.update(camp_sport_day_plan_params)
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "sport_plan"), notice: "Sportplan wurde aktualisiert."
    else
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "sport_plan"), alert: sport_day_plan.errors.full_messages.to_sentence
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

  def camp_sport_day_plan_params
    params.require(:camp_sport_day_plan).permit(:free_sport, :required_sport)
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
