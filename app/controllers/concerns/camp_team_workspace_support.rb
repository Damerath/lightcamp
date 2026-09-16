module CampTeamWorkspaceSupport
  extend ActiveSupport::Concern

  private

  # Teamansicht und Leitungsansicht zeigen denselben Arbeitsbereich.
  # Dieses Concern bündelt die gemeinsame Datenaufbereitung; Berechtigungen
  # und Rücksprung-URLs verbleiben in den jeweiligen Controllern.

  def set_camp
    @camp = Camp.includes(:year).find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:id]).workspace_team
    @camp = @camp_team.camp
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

  def resolve_layout
    print_actions = %w[shopping_print week_plan_print sport_tournament_print kitchen_plan_print diy_plan_print room_plan_print medical_supplies_print]
    print_actions.include?(action_name) ? "print" : "application"
  end

  def prepare_room_plan_print
    # Gruppierte und nicht zugeteilte Personen werden vorbereitet, damit die
    # Druckansicht keine Datenbankabfragen oder Fachlogik enthalten muss.
    @camp.ensure_sleeping_places!
    @camp_sleeping_places = @camp.camp_sleeping_places.ordered
    @camp_room_candidates = @camp.assigned_camp_applications.includes(:user, :assigned_camp_team, :camp_sleeping_place).sort_by(&:display_name)
    @camp_room_assignments_by_place_id = @camp_room_candidates.select { |application| application.camp_sleeping_place_id.present? }.group_by(&:camp_sleeping_place_id)
    @camp_room_people = @camp.camp_room_people.includes(:camp_sleeping_place, related_camp_application: :user).ordered
    @camp_room_people_by_place_id = @camp_room_people.select { |person| person.camp_sleeping_place_id.present? }.group_by(&:camp_sleeping_place_id)
    @unassigned_room_candidates = @camp_room_candidates.select { |application| application.camp_sleeping_place_id.blank? }
    @unassigned_room_people = @camp_room_people.select { |person| person.camp_sleeping_place_id.blank? }
  end

  def prepare_week_plan_print
    # Das Programmteam besitzt den maßgeblichen Wochenplan. Andere Teams lesen
    # die zuvor im Controller bestimmte veröffentlichte Version.
    source_team = @week_plan_source_team || @camp_team
    source_team.ensure_program_default_blocks! if source_team.program_team?
    source_team.sync_program_week_days_to_schedule! if source_team.program_team?
    @camp_program_week_days = source_team.camp_program_week_days.includes(:camp_program_week_blocks).ordered
    @camp_program_week_days_by_date = @camp_program_week_days.index_by(&:planned_on)
    @camp_program_week_dates = @camp.scheduled? ? @camp.day_range : []
  end

  def prepare_medical_supplies_print
    @medical_supply_category = params[:category].to_s
    unless MedicalSupplyItem::CATEGORY_ORDER.include?(@medical_supply_category)
      # Der aufrufende Controller bestimmt, ob er zur Team- oder Leitungsseite zurückgeht.
      redirect_to workspace_page_path(section: "medical_supplies"), alert: "Kategorie nicht gefunden."
      return
    end

    @medical_supply_items_for_print = MedicalSupplyItem.ordered.where(category: @medical_supply_category)
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
