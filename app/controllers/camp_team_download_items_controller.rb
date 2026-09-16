class CampTeamDownloadItemsController < ApplicationController
  include CampTeamAccess
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access

  def create
    item = @camp_team.download_items.new(download_item_params.merge(scope_kind: :camp_team_local, uploader: current_user, position: next_position))

    if item.save
      ::Notifications::Triggers.team_download_added!(camp_team: @camp_team, download_item: item, actor: current_user)
      redirect_to team_page_path(@camp, @camp_team, section: "downloads"), notice: "Datei wurde hochgeladen."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "downloads"), alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = @camp_team.download_items.camp_team_local.find(params[:id])
    item.assign_attributes(download_item_params)
    item.uploader ||= current_user

    if item.save
      redirect_to team_page_path(@camp, @camp_team, section: "downloads"), notice: "Datei wurde aktualisiert."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "downloads"), alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    item = @camp_team.download_items.camp_team_local.find(params[:id])
    item.destroy
    redirect_to team_page_path(@camp, @camp_team, section: "downloads"), notice: "Datei wurde entfernt."
  end

  private

  def download_item_params
    params.require(:download_item).permit(:title, :description, :file)
  end

  def next_position
    (@camp_team.download_items.camp_team_local.maximum(:position) || -1) + 1
  end
end
