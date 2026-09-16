class CampSportDayPlansController < ApplicationController
  include CampTeamAccess
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access

  def update
    sport_day_plan = @camp_team.camp_sport_day_plans.find(params[:id])

    if sport_day_plan.update(camp_sport_day_plan_params)
      redirect_to team_page_path(@camp, @camp_team, section: "sport_plan"), notice: "Sportplan wurde aktualisiert."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "sport_plan"), alert: sport_day_plan.errors.full_messages.to_sentence
    end
  end

  private

  def camp_sport_day_plan_params
    params.require(:camp_sport_day_plan).permit(:free_sport, :required_sport)
  end
end
