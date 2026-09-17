class AddResponsibleUserToTeamTemplates < ActiveRecord::Migration[7.1]
  def change
    add_reference :team_templates, :responsible_user, foreign_key: { to_table: :users, on_delete: :nullify }
  end
end
