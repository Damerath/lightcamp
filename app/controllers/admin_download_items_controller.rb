class AdminDownloadItemsController < ApplicationController
  before_action :require_admin

  def index
    @download_items = DownloadItem.admin_items.includes(:uploader, file_attachment: :blob)
  end

  def create
    item = DownloadItem.new(download_item_params.merge(scope_kind: :admin_only, uploader: current_user, position: next_position))

    if item.save
      redirect_to admin_download_items_path, notice: "Datei wurde hochgeladen."
    else
      redirect_to admin_download_items_path, alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = DownloadItem.admin_only.find(params[:id])
    item.assign_attributes(download_item_params)
    item.uploader ||= current_user

    if item.save
      redirect_to admin_download_items_path, notice: "Datei wurde aktualisiert."
    else
      redirect_to admin_download_items_path, alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    item = DownloadItem.admin_only.find(params[:id])
    item.destroy
    redirect_to admin_download_items_path, notice: "Datei wurde entfernt."
  end

  private

  def download_item_params
    params.require(:download_item).permit(:title, :description, :file)
  end

  def next_position
    (DownloadItem.admin_only.maximum(:position) || -1) + 1
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
