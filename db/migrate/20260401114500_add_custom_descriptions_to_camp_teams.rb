class AddCustomDescriptionsToCampTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :camp_teams, :custom_description, :text
    add_column :camp_teams, :custom_responsible_description, :text
  end
end
