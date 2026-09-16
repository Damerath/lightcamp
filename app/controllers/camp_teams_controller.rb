class CampTeamsController < ApplicationController
  include CampTeamWorkspaceSupport

  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access
  layout :resolve_layout

  def show
    @week_plan_source_team = @camp_team.program_team? ? @camp_team : @camp_team.published_week_plan_source_team
    @week_plan_available = @week_plan_source_team.present?
    @week_plan_read_only = @week_plan_available && @week_plan_source_team != @camp_team
    allowed_sections = %w[overview description todos shopping downloads]
    if @camp_team.sport_team?
      allowed_sections << "sport_plan"
      allowed_sections << "material_list"
    end
    allowed_sections << "medical_supplies" if @camp_team.medical_team?
    if @camp_team.kitchen_team?
      allowed_sections << "kitchen_plan"
      allowed_sections << "recipe_book"
    end
    allowed_sections << "diy_plan" if @camp_team.diy_team?
    allowed_sections << "room_plan" if @camp_team.camp_leader_team?
    allowed_sections << "program" if @camp_team.program_team?
    allowed_sections << "week_plan" if @week_plan_available
    @section = params[:section].presence_in(allowed_sections) || "overview"
    @camp_team_links = @camp_team.camp_team_links.ordered
    @team_template_links = @camp_team.team_template&.team_template_links&.ordered || TeamTemplateLink.none
    @team_template_download_items = @camp_team.team_template.present? ? DownloadItem.default_for_template(@camp_team.team_template).includes(:uploader, file_attachment: :blob) : DownloadItem.none
    @camp_team_download_items = DownloadItem.local_for_team(@camp_team).includes(:uploader, file_attachment: :blob)
    @can_manage_local_downloads = true
    @camp_team_todos = @camp_team.camp_team_todos.ordered
    @camp_team_shopping_items = @camp_team.camp_team_shopping_items.ordered
    if @camp_team.sport_team?
      @camp_team.sync_sport_day_plans_to_schedule!
      sport_team_template = TeamTemplate.find_or_create_by!(name: "Sport")
      @camp_sport_day_plans = @camp_team.camp_sport_day_plans.ordered
      @camp_sport_tournament_plan = @camp_team.ensure_sport_tournament_plan!
      @camp_sport_material_items = sport_team_template.team_template_sport_material_items.ordered
      @camp_sport_material_changes = sport_team_template.team_template_sport_material_changes.includes(:user).recent_first.limit(40)
      @can_manage_sport_materials = @camp_team.sport_material_manager?(current_user)
    end
    if @camp_team.medical_team?
      @medical_supply_items = MedicalSupplyItem.grouped_for_view
      @medical_supply_changes = MedicalSupplyChange.recent_first.limit(50)
      @can_manage_medical_supplies = @camp_team.medical_supply_manager?(current_user)
    end
    if @camp_team.kitchen_team?
      @camp_team.sync_kitchen_day_plans_to_schedule!
      @camp_kitchen_day_plans = @camp_team.camp_kitchen_day_plans.ordered
      @recipes = KitchenRecipe.includes(:ingredients).ordered
      @recipe = KitchenRecipe.find_by(id: params[:recipe_id])
      @ingredients = @recipe&.ingredients&.ordered || KitchenRecipeIngredient.none
      @can_manage_recipes = @camp_team.kitchen_recipe_manager?(current_user)
    end
    if @camp_team.diy_team?
      @camp_team.sync_diy_day_plans_to_schedule!
      @camp_diy_day_plans = @camp_team.camp_diy_day_plans.ordered
    end
    if @camp_team.camp_leader_team?
      @camp.ensure_sleeping_places!
      @camp_sleeping_places = @camp.camp_sleeping_places.includes(camp_applications: [:user, :assigned_camp_team]).ordered
      @camp_room_candidates = @camp.assigned_camp_applications.includes(:user, :assigned_camp_team, :camp_sleeping_place).sort_by(&:display_name)
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
    @show_responsible_description = @camp_team.supports_responsible_description? && (current_user&.management? || @viewer_assignment&.assigned_as_responsible?)
    @assigned_applications = @camp_team.assigned_workspace_applications.includes(:user).sort_by(&:display_name)
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

  def medical_supplies_print
    return redirect_to camp_team_page_path(@camp, @camp_team), alert: "Nur fuer die Krankenpflege verfuegbar." unless @camp_team.medical_team?

    prepare_medical_supplies_print
  end

  def update
    previous_meeting_at = @camp_team.next_internal_meeting_at
    previous_week_plan_published = @camp_team.week_plan_published?
    changed_attributes = team_update_params

    if @camp_team.update(changed_attributes)
      if changed_attributes.key?(:next_internal_meeting_at) && previous_meeting_at != @camp_team.next_internal_meeting_at && @camp_team.next_internal_meeting_at.present?
        ::Notifications::Triggers.team_meeting_changed!(
          camp_team: @camp_team,
          actor: current_user,
          changed: previous_meeting_at.present? ? :updated : :created
        )
      end

      if @camp_team.program_team? && !previous_week_plan_published && @camp_team.week_plan_published?
        ::Notifications::Triggers.week_plan_published!(program_team: @camp_team, actor: current_user)
      end

      redirect_to camp_team_page_path(@camp, @camp_team, section: params[:section].presence || "overview"), notice: "Teamseite wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: params[:section].presence || "overview"), alert: @camp_team.errors.full_messages.to_sentence
    end
  end

  private

  def workspace_page_path(section: nil)
    camp_team_page_path(@camp, @camp_team, section: section)
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

  def require_team_access
    return if current_user&.management?
    return if current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diese Teamseite."
  end
end
