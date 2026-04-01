class AdminSportMaterialListsController < ApplicationController
  before_action :require_admin
  before_action :set_sport_team_template

  def show
    @sort_column = params[:sort].presence_in(%w[name quantity storage_location]) || "storage_location"
    @sort_direction = params[:direction].presence_in(%w[asc desc]) || "asc"
    @sport_material_items = @team_template.team_template_sport_material_items.order(Arel.sql("#{sort_column_sql(@sort_column)} #{@sort_direction}, name ASC, id ASC"))
    @sport_material_changes = @team_template.team_template_sport_material_changes.includes(:user).recent_first.limit(40)
  end

  def create
    item = @team_template.team_template_sport_material_items.new(sport_material_item_params.merge(position: next_position))

    if item.save
      TeamTemplateSportMaterialChange.log!(
        team_template: @team_template,
        user: current_user,
        material_name: item.name,
        change_type: "create",
        change_summary: "Angelegt: Menge #{item.quantity.presence || '-'}, Ort #{item.storage_location.presence || '-'}"
      )
      redirect_to admin_sport_material_list_path, notice: "Default-Material wurde gespeichert."
    else
      redirect_to admin_sport_material_list_path, alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = @team_template.team_template_sport_material_items.find(params[:id])
    previous = item.attributes.slice("name", "quantity", "storage_location")

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
      redirect_to admin_sport_material_list_path, notice: "Default-Material wurde aktualisiert."
    else
      redirect_to admin_sport_material_list_path, alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    item = @team_template.team_template_sport_material_items.find(params[:id])
    summary = "Entfernt: Menge #{item.quantity.presence || '-'}, Ort #{item.storage_location.presence || '-'}"
    material_name = item.name
    item.destroy

    TeamTemplateSportMaterialChange.log!(
      team_template: @team_template,
      user: current_user,
      material_name: material_name,
      change_type: "destroy",
      change_summary: summary
    )

    redirect_to admin_sport_material_list_path, notice: "Default-Material wurde entfernt."
  end

  private

  def set_sport_team_template
    @team_template = TeamTemplate.find_or_create_by!(name: "Sport")
  end

  def sport_material_item_params
    params.require(:team_template_sport_material_item).permit(:name, :quantity, :storage_location)
  end

  def next_position
    (@team_template.team_template_sport_material_items.maximum(:position) || -1) + 1
  end

  def sort_column_sql(column)
    case column
    when "name"
      "LOWER(name)"
    when "quantity"
      "LOWER(quantity)"
    else
      "LOWER(storage_location)"
    end
  end

  def build_update_summary(previous, item)
    changes = []
    changes << "Name von #{previous['name']} auf #{item.name}" if previous["name"] != item.name
    changes << "Menge von #{previous['quantity'].presence || '-'} auf #{item.quantity.presence || '-'}" if previous["quantity"] != item.quantity
    changes << "Ort von #{previous['storage_location'].presence || '-'} auf #{item.storage_location.presence || '-'}" if previous["storage_location"] != item.storage_location
    changes.present? ? "Aktualisiert: #{changes.join('; ')}" : nil
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
