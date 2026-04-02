class CampSportMaterialItemsController < ApplicationController
  before_action :set_camp
  before_action :set_camp_team
  before_action :set_sport_team_template
  before_action :require_team_access
  before_action :require_sport_material_manager

  def create
    item = @team_template.team_template_sport_material_items.new(sport_material_item_params.merge(position: next_position))

    if item.save
      TeamTemplateSportMaterialChange.log!(
        team_template: @team_template,
        user: current_user,
        material_name: item.name,
        change_type: "create",
        change_summary: "Angelegt: Menge #{item.quantity.presence || '-'}, Ort #{item.storage_location.presence || '-'}, Anmerkung #{item.notes.presence || '-'}"
      )
      redirect_to camp_team_page_path(@camp, @camp_team, section: "material_list"), notice: "Material wurde hinzugefügt."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "material_list"), alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = @team_template.team_template_sport_material_items.find(params[:id])
    previous = item.attributes.slice("name", "quantity", "storage_location", "notes")

    if item.update(sport_material_item_params)
      summary = build_update_summary(previous, item)
      if summary.present?
        TeamTemplateSportMaterialChange.log!(
          team_template: @team_template,
          user: current_user,
          material_name: item.name,
          change_type: "update",
          change_summary: summary
        )
      end
      redirect_to camp_team_page_path(@camp, @camp_team, section: "material_list"), notice: "Material wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "material_list"), alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    item = @team_template.team_template_sport_material_items.find(params[:id])
    summary = "Entfernt: Menge #{item.quantity.presence || '-'}, Ort #{item.storage_location.presence || '-'}, Anmerkung #{item.notes.presence || '-'}"
    material_name = item.name
    item.destroy

    TeamTemplateSportMaterialChange.log!(
      team_template: @team_template,
      user: current_user,
      material_name: material_name,
      change_type: "destroy",
      change_summary: summary
    )

    redirect_to camp_team_page_path(@camp, @camp_team, section: "material_list"), notice: "Material wurde entfernt."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def set_sport_team_template
    @team_template = TeamTemplate.find_or_create_by!(name: "Sport")
  end

  def sport_material_item_params
    params.require(:team_template_sport_material_item).permit(:name, :quantity, :storage_location, :notes)
  end

  def next_position
    (@team_template.team_template_sport_material_items.maximum(:position) || -1) + 1
  end

  def require_team_access
    return if current_user&.admin?
    return if current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diese Teamseite."
  end

  def require_sport_material_manager
    return if @camp_team.sport_material_manager?(current_user)

    redirect_to camp_team_page_path(@camp, @camp_team, section: "material_list"), alert: "Nur Verantwortliche dürfen die Materialliste bearbeiten."
  end

  def build_update_summary(previous, item)
    changes = []
    changes << "Name von #{previous['name']} auf #{item.name}" if previous["name"] != item.name
    changes << "Menge von #{previous['quantity'].presence || '-'} auf #{item.quantity.presence || '-'}" if previous["quantity"] != item.quantity
    changes << "Ort von #{previous['storage_location'].presence || '-'} auf #{item.storage_location.presence || '-'}" if previous["storage_location"] != item.storage_location
    changes << "Anmerkung von #{previous['notes'].presence || '-'} auf #{item.notes.presence || '-'}" if previous["notes"] != item.notes
    changes.present? ? "Aktualisiert: #{changes.join('; ')}" : nil
  end
end
