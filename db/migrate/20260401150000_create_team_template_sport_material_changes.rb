class CreateTeamTemplateSportMaterialChanges < ActiveRecord::Migration[7.1]
  def change
    create_table :team_template_sport_material_changes do |t|
      t.references :team_template, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :actor_name, null: false, default: ""
      t.string :material_name, null: false
      t.string :change_type, null: false
      t.text :change_summary, null: false
      t.timestamps
    end

    add_index :team_template_sport_material_changes, [:team_template_id, :created_at], name: "idx_tt_sport_material_changes_on_template_and_created_at"
  end
end
