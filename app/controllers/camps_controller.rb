class CampsController < ApplicationController
  def index
    applications = current_user.camp_applications
      .includes(assigned_camp: :year, assigned_camp_team: { camp: :year })
      .where.not(assigned_camp_team_id: nil)

    @assigned_teams_by_year = applications
      .select(&:assigned_camp_team)
      .group_by { |application| application.assigned_camp.year }
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
    params.require(:camp).permit(:name, :year_id, :start_on, :end_on)
  end
end
