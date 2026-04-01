class AdminTeamTemplateSportMaterialItemsController < ApplicationController
  before_action :require_admin
  before_action :set_team_template

  def create
    item = @team_template.team_template_sport_material_items.new(team_template_sport_material_item_params.merge(position: next_position))

    if item.save
      redirect_to admin_team_template_path(@team_template), notice: "Default-Material wurde gespeichert."
    else
      redirect_to admin_team_template_path(@team_template), alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = @team_template.team_template_sport_material_items.find(params[:id])

    if item.update(team_template_sport_material_item_params)
      redirect_to admin_team_template_path(@team_template), notice: "Default-Material wurde aktualisiert."
    else
      redirect_to admin_team_template_path(@team_template), alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    item = @team_template.team_template_sport_material_items.find(params[:id])
    item.destroy

    redirect_to admin_team_template_path(@team_template), notice: "Default-Material wurde entfernt."
  end

  private

  def set_team_template
    @team_template = TeamTemplate.find(params[:team_template_id])
  end

  def team_template_sport_material_item_params
    params.require(:team_template_sport_material_item).permit(:name, :quantity, :storage_location)
  end

  def next_position
    (@team_template.team_template_sport_material_items.maximum(:position) || -1) + 1
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
