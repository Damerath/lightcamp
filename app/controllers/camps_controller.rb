class CampsController < ApplicationController
  def index
    @years = Year.includes(:camps).order(name: :desc)
  end

  def create
    camp = Camp.new(camp_params)

    if camp.save
      redirect_to admin_camps_path, notice: "Camp wurde erstellt."
    else
      redirect_to admin_camps_path(modal: "new_camp"), alert: "Camp konnte nicht erstellt werden."
    end
  end

  def update
    camp = Camp.find(params[:id])

    if camp.update(camp_params)
      redirect_to admin_camps_path, notice: "Camp wurde aktualisiert."
    else
      redirect_to admin_camps_path(modal: "edit_camp", camp_id: camp.id), alert: "Fehler beim Speichern."
    end
  end

  def destroy
    camp = Camp.find(params[:id])

    camp.destroy

    redirect_to admin_camps_path, notice: "Camp wurde gelöscht."
  end
  
  private

  def camp_params
    params.require(:camp).permit(:name, :year_id)
  end
end