class AdminTeamTemplateDownloadItemsController < ApplicationController
  before_action :require_admin
  before_action :set_team_template

  def create
    item = @team_template.download_items.new(download_item_params.merge(scope_kind: :team_template_default, uploader: current_user, position: next_position))

    if item.save
      redirect_to admin_team_template_path(@team_template), notice: "Default-Datei wurde hochgeladen."
    else
      redirect_to admin_team_template_path(@team_template), alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = @team_template.download_items.team_template_default.find(params[:id])
    item.assign_attributes(download_item_params)
    item.uploader ||= current_user

    if item.save
      redirect_to admin_team_template_path(@team_template), notice: "Default-Datei wurde aktualisiert."
    else
      redirect_to admin_team_template_path(@team_template), alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    item = @team_template.download_items.team_template_default.find(params[:id])
    item.destroy
    redirect_to admin_team_template_path(@team_template), notice: "Default-Datei wurde entfernt."
  end

  private

  def set_team_template
    @team_template = TeamTemplate.find(params[:team_template_id])
  end

  def download_item_params
    params.require(:download_item).permit(:title, :description, :file)
  end

  def next_position
    (@team_template.download_items.team_template_default.maximum(:position) || -1) + 1
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
