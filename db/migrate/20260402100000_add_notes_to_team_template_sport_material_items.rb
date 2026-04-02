class AddNotesToTeamTemplateSportMaterialItems < ActiveRecord::Migration[7.1]
  def change
    add_column :team_template_sport_material_items, :notes, :text
  end
end
