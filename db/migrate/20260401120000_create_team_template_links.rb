class CreateTeamTemplateLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :team_template_links do |t|
      t.references :team_template, null: false, foreign_key: true
      t.string :title, null: false
      t.string :url, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
