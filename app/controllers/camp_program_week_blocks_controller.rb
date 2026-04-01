class CampProgramWeekBlocksController < ApplicationController
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access

  def create
    week_day = @camp_team.camp_program_week_days.find(params[:week_day_id])
    block = week_day.camp_program_week_blocks.new(camp_program_week_block_params.merge(position: next_position(week_day)))

    if block.save
      sync_matching_colors!(block)
      redirect_to camp_team_page_path(@camp, @camp_team, section: "week_plan"), notice: "Wochenplan-Block wurde gespeichert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "week_plan"), alert: block.errors.full_messages.to_sentence
    end
  end

  def update
    block = find_block

    if block.update(camp_program_week_block_params)
      sync_matching_colors!(block)
      redirect_to camp_team_page_path(@camp, @camp_team, section: "week_plan"), notice: "Wochenplan-Block wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "week_plan"), alert: block.errors.full_messages.to_sentence
    end
  end

  def destroy
    block = find_block
    block.destroy

    redirect_to camp_team_page_path(@camp, @camp_team, section: "week_plan"), notice: "Wochenplan-Block wurde entfernt."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def find_block
    @camp_team.camp_program_week_days.joins(:camp_program_week_blocks)
              .merge(CampProgramWeekBlock.where(id: params[:id]))
              .first!
              .camp_program_week_blocks
              .find(params[:id])
  end

  def camp_program_week_block_params
    permitted = params.require(:camp_program_week_block).permit(:title, :starts_at_hour, :starts_at_minute, :visible_to_others, :color)

    {
      title: permitted[:title],
      starts_at_minutes: (permitted[:starts_at_hour].to_i * 60) + permitted[:starts_at_minute].to_i,
      visible_to_others: ActiveModel::Type::Boolean.new.cast(permitted[:visible_to_others]),
      color: permitted[:color].presence || "blue"
    }
  end

  def next_position(week_day)
    (week_day.camp_program_week_blocks.maximum(:position) || -1) + 1
  end

  def sync_matching_colors!(block)
    normalized_title = block.normalized_title
    return if normalized_title.blank?

    CampProgramWeekBlock.joins(:camp_program_week_day)
              .where(camp_program_week_days: { camp_team_id: @camp_team.id })
              .where("LOWER(BTRIM(camp_program_week_blocks.title)) = ?", normalized_title)
              .where.not(id: block.id)
              .update_all(color: block.color)
  end

  def require_team_access
    return if current_user&.admin?
    return if current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diese Teamseite."
  end
end
