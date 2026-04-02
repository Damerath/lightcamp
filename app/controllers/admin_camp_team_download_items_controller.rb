class AdminCampTeamDownloadItemsController < ApplicationController
  before_action :require_admin
  before_action :set_camp
  before_action :set_camp_team

  def create
    item = @camp_team.download_items.new(download_item_params.merge(scope_kind: :camp_team_local, uploader: current_user, position: next_position))

    if item.save
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "downloads"), notice: "Datei wurde hochgeladen."
    else
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "downloads"), alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = @camp_team.download_items.camp_team_local.find(params[:id])
    item.assign_attributes(download_item_params)
    item.uploader ||= current_user

    if item.save
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "downloads"), notice: "Datei wurde aktualisiert."
    else
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "downloads"), alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    item = @camp_team.download_items.camp_team_local.find(params[:id])
    item.destroy
    redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "downloads"), notice: "Datei wurde entfernt."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def download_item_params
    params.require(:download_item).permit(:title, :description, :file)
  end

  def next_position
    (@camp_team.download_items.camp_team_local.maximum(:position) || -1) + 1
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
