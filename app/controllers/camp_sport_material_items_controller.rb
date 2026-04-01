class CampSportMaterialItemsController < ApplicationController
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access
  before_action :require_sport_material_manager

  def create
    item = @camp_team.camp_sport_material_items.new(camp_sport_material_item_params.merge(position: next_position))

    if item.save
      CampSportMaterialChange.log!(
        camp_team: @camp_team,
        user: current_user,
        material_name: item.name,
        change_type: "create",
        change_summary: "Angelegt: Menge #{item.quantity}, Ort #{item.storage_location}"
      )
      redirect_to camp_team_page_path(@camp, @camp_team, section: "sport_plan"), notice: "Material wurde hinzugefügt."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "sport_plan"), alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = @camp_team.camp_sport_material_items.find(params[:id])
    previous = item.attributes.slice("name", "quantity", "storage_location")

    if item.update(camp_sport_material_item_params)
      summary = build_update_summary(previous, item)
      if summary.present?
        CampSportMaterialChange.log!(
          camp_team: @camp_team,
          user: current_user,
          material_name: item.name,
          change_type: "update",
          change_summary: summary
        )
      end
      redirect_to camp_team_page_path(@camp, @camp_team, section: "sport_plan"), notice: "Material wurde aktualisiert."
    else
      redirect_to camp_team_page_path(@camp, @camp_team, section: "sport_plan"), alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    item = @camp_team.camp_sport_material_items.find(params[:id])
    summary = "Entfernt: Menge #{item.quantity}, Ort #{item.storage_location}"
    material_name = item.name
    item.destroy

    CampSportMaterialChange.log!(
      camp_team: @camp_team,
      user: current_user,
      material_name: material_name,
      change_type: "destroy",
      change_summary: summary
    )

    redirect_to camp_team_page_path(@camp, @camp_team, section: "sport_plan"), notice: "Material wurde entfernt."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def camp_sport_material_item_params
    params.require(:camp_sport_material_item).permit(:name, :quantity, :storage_location)
  end

  def next_position
    (@camp_team.camp_sport_material_items.maximum(:position) || -1) + 1
  end

  def require_team_access
    return if current_user&.admin?
    return if current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diese Teamseite."
  end

  def require_sport_material_manager
    return if @camp_team.sport_material_manager?(current_user)

    redirect_to camp_team_page_path(@camp, @camp_team, section: "sport_plan"), alert: "Nur Verantwortliche dürfen die Materialliste bearbeiten."
  end

  def build_update_summary(previous, item)
    changes = []
    changes << "Name von #{previous['name']} auf #{item.name}" if previous["name"] != item.name
    changes << "Menge von #{previous['quantity']} auf #{item.quantity}" if previous["quantity"] != item.quantity
    changes << "Ort von #{previous['storage_location']} auf #{item.storage_location}" if previous["storage_location"] != item.storage_location
    changes.present? ? "Aktualisiert: #{changes.join('; ')}" : nil
  end
end
