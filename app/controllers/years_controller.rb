class YearsController < ApplicationController
  def index
    @years = Year.all
  end

  def create
    year = Year.new(year_params)

    if year.save
      redirect_to admin_camps_path, notice: "Jahr wurde erstellt."
    else
      redirect_to admin_camps_path(modal: "new_year"), alert: "Jahr konnte nicht erstellt werden."
    end
  end

  def update
    year = Year.find(params[:id])

    if year.update(year_params)
      redirect_to admin_camps_path, notice: "Jahr wurde aktualisiert."
    else
      redirect_to admin_camps_path(modal: "edit_year", year_id: year.id), alert: "Fehler beim Speichern."
    end
  end
  
  private

  def year_params
    params.require(:year).permit(:name)
  end
end