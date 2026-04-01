class AddResponsibleDescriptionToTeamTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :team_templates, :responsible_description, :text
  end
end
