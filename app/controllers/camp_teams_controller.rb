class CampTeamsController < ApplicationController
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access
  layout :resolve_layout

  def show
    @week_plan_source_team = @camp_team.program_team? ? @camp_team : @camp_team.published_week_plan_source_team
    @week_plan_available = @week_plan_source_team.present?
    @week_plan_read_only = @week_plan_available && @week_plan_source_team != @camp_team
    allowed_sections = %w[overview description todos shopping]
    if @camp_team.sport_team?
      allowed_sections << "sport_plan"
      allowed_sections << "material_list"
    end
    allowed_sections << "kitchen_plan" if @camp_team.kitchen_team?
    allowed_sections << "diy_plan" if @camp_team.diy_team?
    allowed_sections << "room_plan" if @camp_team.camp_leader_team?
    allowed_sections << "program" if @camp_team.program_team?
    allowed_sections << "week_plan" if @week_plan_available
    @section = params[:section].presence_in(allowed_sections) || "overview"
    @camp_team_links = @camp_team.camp_team_links.ordered
    @team_template_links = @camp_team.team_template&.team_template_links&.ordered || TeamTemplateLink.none
    @camp_team_todos = @camp_team.camp_team_todos.ordered
    @camp_team_shopping_items = @camp_team.camp_team_shopping_items.ordered
    if @camp_team.sport_team?
      @camp_team.sync_sport_day_plans_to_schedule!
      @camp_team.ensure_sport_material_items!
      @camp_sport_day_plans = @camp_team.camp_sport_day_plans.ordered
      @camp_sport_tournament_plan = @camp_team.ensure_sport_tournament_plan!
      @camp_sport_material_items = @camp_team.camp_sport_material_items.ordered
      @camp_sport_material_changes = @camp_team.camp_sport_material_changes.includes(:user).recent_first.limit(40)
      @can_manage_sport_materials = @camp_team.sport_material_manager?(current_user)
    end
    if @camp_team.kitchen_team?
      @camp_team.sync_kitchen_day_plans_to_schedule!
      @camp_kitchen_day_plans = @camp_team.camp_kitchen_day_plans.ordered
    end
    if @camp_team.diy_team?
      @camp_team.sync_diy_day_plans_to_schedule!
      @camp_diy_day_plans = @camp_team.camp_diy_day_plans.ordered
    end
    if @camp_team.camp_leader_team?
      @camp.ensure_sleeping_places!
      @camp_sleeping_places = @camp.camp_sleeping_places.includes(camp_applications: [:user, :assigned_camp_team]).ordered
      @camp_room_candidates = @camp.assigned_camp_applications.includes(:user, :assigned_camp_team, :camp_sleeping_place).sort_by { |application| [application.user.last_name.to_s, application.user.first_name.to_s] }
      @camp_room_assignments_by_place_id = @camp_room_candidates.select { |application| application.camp_sleeping_place_id.present? }.group_by(&:camp_sleeping_place_id)
      @camp_room_people = @camp.camp_room_people.includes(:camp_sleeping_place, related_camp_application: :user).ordered
      @camp_room_people_by_place_id = @camp_room_people.select { |person| person.camp_sleeping_place_id.present? }.group_by(&:camp_sleeping_place_id)
    end
    @camp_team.ensure_program_default_blocks! if @camp_team.program_team?
    @week_plan_source_team&.ensure_program_default_blocks! if @week_plan_source_team&.program_team?
    @week_plan_source_team&.sync_program_week_days_to_schedule! if @week_plan_source_team&.program_team?
    @camp_program_blocks = @camp_team.camp_program_blocks.ordered
    @camp_program_week_days = (@week_plan_source_team || @camp_team).camp_program_week_days.includes(:camp_program_week_blocks).ordered
    @camp_program_week_days_by_date = @camp_program_week_days.index_by(&:planned_on)
    @camp_program_week_dates = @camp.scheduled? ? @camp.day_range : []
    @program_week_day_modal = build_program_week_day_modal
    @program_block_modal = build_program_block_modal
    @program_week_block_modal = build_program_week_block_modal
    @viewer_assignment = current_user&.camp_applications&.find_by(assigned_camp_team_id: @camp_team.workspace_team_ids)
    @show_responsible_description = @camp_team.supports_responsible_description? && (current_user&.admin? || @viewer_assignment&.assigned_as_responsible?)
    @assigned_applications = @camp_team.assigned_workspace_applications.includes(:user).sort_by { |application| [application.user.last_name.to_s, application.user.first_name.to_s] }
  end

  def shopping_print
    @camp_team_shopping_items = @camp_team.camp_team_shopping_items.ordered
    @open_shopping_items = @camp_team_shopping_items.reject(&:purchased?)
    @completed_shopping_items = @camp_team_shopping_items.select(&:purchased?)
  end

  def week_plan_print
    @week_plan_source_team = @camp_team.program_team? ? @camp_team : @camp.published_program_team
    return redirect_to camp_team_page_path(@camp, @camp_team), alert: "Kein veröffentlichter Wochenplan vorhanden." if @week_plan_source_team.blank?

    prepare_week_plan_print
  end

  def sport_tournament_print
    return redirect_to camp_team_page_path(@camp, @camp_team, section: "sport_plan"), alert: "Nur fuer das Sport-Team verfuegbar." unless @camp_team.sport_team?

    @camp_sport_tournament_plan = @camp_team.ensure_sport_tournament_plan!
  end

  def kitchen_plan_print
    return redirect_to camp_team_page_path(@camp, @camp_team, section: "kitchen_plan"), alert: "Nur fuer das Küchen-Team verfuegbar." unless @camp_team.kitchen_team?

    @camp_team.sync_kitchen_day_plans_to_schedule!
    @camp_kitchen_day_plans = @camp_team.camp_kitchen_day_plans.ordered
  end

  def diy_plan_print
    return redirect_to camp_team_page_path(@camp, @camp_team, section: "diy_plan"), alert: "Nur fuer das DIY-Team verfuegbar." unless @camp_team.diy_team?

    @camp_team.sync_diy_day_plans_to_schedule!
    @camp_diy_day_plans = @camp_team.camp_diy_day_plans.ordered
  end

  def room_plan_print
    return redirect_to camp_team_page_path(@camp, @camp_team, section: "room_plan"), alert: "Nur fuer das Freizeitleiter-Team verfuegbar." unless @camp_team.camp_leader_team?

    prepare_room_plan_print
  end

  def update
    if @camp_team.update(team_update_params)
      redirect_to camp_team_page_path(@camp, @camp_team, section: params[:section].presence || "overview"), notice: "Teamseite wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: params[:section].presence || "overview"), alert: @camp_team.errors.full_messages.to_sentence
    end
  end

  private

  def set_camp
    @camp = Camp.includes(:year).find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:id]).workspace_team
    @camp = @camp_team.camp
  end

  def team_update_params
    permitted = params.require(:camp_team).permit(:next_internal_meeting_on, :next_internal_meeting_hour, :next_internal_meeting_minute, :week_plan_published)
    attributes = {}

    if params[:camp_team].key?(:next_internal_meeting_on) || params[:camp_team].key?(:next_internal_meeting_hour) || params[:camp_team].key?(:next_internal_meeting_minute)
      meeting_on = permitted[:next_internal_meeting_on].presence
      meeting_time = combine_time_parts(permitted[:next_internal_meeting_hour], permitted[:next_internal_meeting_minute])
      attributes[:next_internal_meeting_at] = combine_meeting_values(meeting_on, meeting_time)
    end

    if @camp_team.program_team? && params[:camp_team].key?(:week_plan_published)
      attributes[:week_plan_published] = ActiveModel::Type::Boolean.new.cast(permitted[:week_plan_published])
    end

    attributes
  end

  def combine_meeting_values(meeting_on, meeting_time)
    return nil if meeting_on.blank?

    time_string = meeting_time.presence || "00:00"
    Time.zone.parse("#{meeting_on} #{time_string}")
  end

  def combine_time_parts(hour, minute)
    return nil if hour.blank? && minute.blank?

    "#{hour.presence || '00'}:#{minute.presence || '00'}"
  end

  def require_team_access
    return if current_user&.admin?
    return if current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diese Teamseite."
  end

  def resolve_layout
    %w[shopping_print week_plan_print sport_tournament_print kitchen_plan_print diy_plan_print room_plan_print].include?(action_name) ? "print" : "application"
  end

  def prepare_room_plan_print
    @camp.ensure_sleeping_places!
    @camp_sleeping_places = @camp.camp_sleeping_places.ordered
    @camp_room_candidates = @camp.assigned_camp_applications.includes(:user, :assigned_camp_team, :camp_sleeping_place).sort_by { |application| [application.user.last_name.to_s, application.user.first_name.to_s] }
    @camp_room_assignments_by_place_id = @camp_room_candidates.select { |application| application.camp_sleeping_place_id.present? }.group_by(&:camp_sleeping_place_id)
    @camp_room_people = @camp.camp_room_people.includes(:camp_sleeping_place, related_camp_application: :user).ordered
    @camp_room_people_by_place_id = @camp_room_people.select { |person| person.camp_sleeping_place_id.present? }.group_by(&:camp_sleeping_place_id)
    @unassigned_room_candidates = @camp_room_candidates.select { |application| application.camp_sleeping_place_id.blank? }
    @unassigned_room_people = @camp_room_people.select { |person| person.camp_sleeping_place_id.blank? }
  end

  def prepare_week_plan_print
    source_team = @week_plan_source_team || @camp_team
    source_team.ensure_program_default_blocks! if source_team.program_team?
    source_team.sync_program_week_days_to_schedule! if source_team.program_team?
    @camp_program_week_days = source_team.camp_program_week_days.includes(:camp_program_week_blocks).ordered
    @camp_program_week_days_by_date = @camp_program_week_days.index_by(&:planned_on)
    @camp_program_week_dates = @camp.scheduled? ? @camp.day_range : []
  end

  def build_program_block_modal
    return unless @section == "program"

    case params[:modal]
    when "new_program_block"
      @camp_team.camp_program_blocks.new(starts_at_minutes: 8 * 60, visible_to_others: true, color: "blue")
    when "edit_program_block"
      @camp_team.camp_program_blocks.find_by(id: params[:program_block_id])
    end
  end

  def build_program_week_block_modal
    return unless @section == "week_plan"
    return if @week_plan_read_only

    case params[:modal]
    when "new_week_block"
      week_day = @camp_team.camp_program_week_days.find_by(id: params[:week_day_id])
      return if week_day.blank?

      week_day.camp_program_week_blocks.new(starts_at_minutes: 8 * 60, visible_to_others: true, color: "blue")
    when "edit_week_block"
      @camp_team.camp_program_week_days.joins(:camp_program_week_blocks)
                .merge(CampProgramWeekBlock.where(id: params[:week_block_id]))
                .first
                &.camp_program_week_blocks
                &.find_by(id: params[:week_block_id])
    end
  end

  def build_program_week_day_modal
    return unless @section == "week_plan"
    return if @week_plan_read_only
    return unless params[:modal] == "edit_week_day"

    @camp_program_week_days.find_by(id: params[:week_day_id])
  end
end
