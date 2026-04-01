class AdminCampProgramBlocksController < ApplicationController
  before_action :require_admin
  before_action :set_camp
  before_action :set_camp_team

  def create
    block = @camp_team.camp_program_blocks.new(camp_program_block_params.merge(position: next_position))

    if block.save
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "program"), notice: "Tagesplan-Block wurde gespeichert."
    else
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "program"), alert: block.errors.full_messages.to_sentence
    end
  end

  def update
    block = @camp_team.camp_program_blocks.find(params[:id])

    if block.update(camp_program_block_params)
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "program"), notice: "Tagesplan-Block wurde aktualisiert."
    else
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "program"), alert: block.errors.full_messages.to_sentence
    end
  end

  def destroy
    block = @camp_team.camp_program_blocks.find(params[:id])
    block.destroy

    redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "program"), notice: "Tagesplan-Block wurde entfernt."
  end

  def reset
    @camp_team.camp_program_blocks.destroy_all
    @camp_team.ensure_program_default_blocks!

    redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "program"), notice: "Standard-Tagesplan wurde wiederhergestellt."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def camp_program_block_params
    permitted = params.require(:camp_program_block).permit(:title, :starts_at_hour, :starts_at_minute, :visible_to_others, :color)

    {
      title: permitted[:title],
      starts_at_minutes: combine_time_parts(permitted[:starts_at_hour], permitted[:starts_at_minute]),
      visible_to_others: ActiveModel::Type::Boolean.new.cast(permitted[:visible_to_others]),
      color: permitted[:color].presence || "blue"
    }
  end

  def combine_time_parts(hour, minute)
    (hour.to_i * 60) + minute.to_i
  end

  def next_position
    (@camp_team.camp_program_blocks.maximum(:position) || -1) + 1
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
