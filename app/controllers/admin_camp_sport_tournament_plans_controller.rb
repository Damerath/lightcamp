class AdminCampSportTournamentPlansController < ApplicationController
  before_action :require_admin
  before_action :set_camp
  before_action :set_camp_team

  def update
    tournament_plan = @camp_team.ensure_sport_tournament_plan!

    if tournament_plan.update(camp_sport_tournament_plan_params)
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "sport_plan"), notice: "Turniervorlage wurde aktualisiert."
    else
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "sport_plan"), alert: tournament_plan.errors.full_messages.to_sentence
    end
  end

  def reset
    tournament_plan = @camp_team.ensure_sport_tournament_plan!
    tournament_plan.reset_to_defaults!

    redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "sport_plan"), notice: "Turniervorlage wurde geleert."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def camp_sport_tournament_plan_params
    permitted = params.require(:camp_sport_tournament_plan).permit(
      :round_interval_minutes,
      :round_note,
      :group1_name,
      :group2_name,
      :group3_name,
      :group4_name,
      :group5_name,
      :station1_name,
      :station2_name,
      :station3_name,
      :station4_name,
      :station5_name,
      :start_hour,
      :start_minute
    )

    permitted.except(:start_hour, :start_minute).merge(
      start_time_minutes: combine_start_time(permitted[:start_hour], permitted[:start_minute])
    )
  end

  def combine_start_time(hour, minute)
    ((hour.presence || "15").to_i * 60) + (minute.presence || "00").to_i
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
