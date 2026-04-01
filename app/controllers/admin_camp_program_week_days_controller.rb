class AdminCampProgramWeekDaysController < ApplicationController
  before_action :require_admin
  before_action :set_camp
  before_action :set_camp_team

  def create
    week_day = @camp_team.camp_program_week_days.find_or_initialize_by(planned_on: planned_on_param)
    week_day.position ||= next_position
    week_day.mode = camp_program_week_day_params[:mode]

    if valid_planned_on?(week_day.planned_on) && week_day.save
      apply_mode_template!(week_day) if week_day.default_plan?
      if params[:open_modal] == "new_week_block"
        redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "week_plan", modal: "new_week_block", week_day_id: week_day.id), notice: "Wochenplan-Tag wurde angelegt."
      elsif params[:open_modal] == "edit_week_day"
        redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "week_plan", modal: "edit_week_day", week_day_id: week_day.id), notice: "Wochenplan-Tag wurde angelegt."
      else
        redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "week_plan"), notice: "Wochenplan-Tag wurde angelegt."
      end
    else
      message = week_day.errors.full_messages.to_sentence.presence || "Der Tag liegt nicht im Camp-Zeitraum."
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "week_plan"), alert: message
    end
  end

  def update
    week_day = @camp_team.camp_program_week_days.find(params[:id])
    attributes = {}
    target_mode = camp_program_week_day_params[:mode]
    attributes[:mode] = target_mode if target_mode.present?
    attributes[:label] = camp_program_week_day_params[:label] if params[:camp_program_week_day].key?(:label)

    if attributes.present? && week_day.update(attributes)
      apply_mode_template!(week_day) if target_mode == "default_plan"
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "week_plan"), notice: "Wochenplan-Tag wurde aktualisiert."
    else
      message = week_day.errors.full_messages.to_sentence.presence || "Der Wochenplan-Tag konnte nicht aktualisiert werden."
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "week_plan"), alert: message
    end
  end

  def destroy
    week_day = @camp_team.camp_program_week_days.find(params[:id])
    week_day.destroy

    redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "week_plan"), notice: "Der Tag wurde aus dem Wochenplan entfernt."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def camp_program_week_day_params
    params.require(:camp_program_week_day).permit(:mode, :label)
  end

  def planned_on_param
    Date.iso8601(params.require(:camp_program_week_day)[:planned_on])
  rescue ArgumentError, TypeError, KeyError
    nil
  end

  def valid_planned_on?(date)
    date.present? && @camp.day_range.include?(date)
  end

  def next_position
    (@camp_team.camp_program_week_days.maximum(:position) || -1) + 1
  end

  def apply_mode_template!(week_day)
    preferred_colors = preferred_week_block_colors
    week_day.camp_program_week_blocks.destroy_all

    @camp_team.camp_program_blocks.ordered.each_with_index do |block, index|
      week_day.camp_program_week_blocks.create!(
        title: block.title,
        starts_at_minutes: block.starts_at_minutes,
        visible_to_others: block.visible_to_others,
        position: index,
        color: preferred_colors.fetch(normalized_title(block.title), block.color)
      )
    end
  end

  def preferred_week_block_colors
    CampProgramWeekBlock.joins(:camp_program_week_day)
                        .where(camp_program_week_days: { camp_team_id: @camp_team.id })
                        .order(:id)
                        .each_with_object({}) do |block, colors|
      key = normalized_title(block.title)
      colors[key] ||= block.color if key.present?
    end
  end

  def normalized_title(title)
    title.to_s.squish.downcase
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
