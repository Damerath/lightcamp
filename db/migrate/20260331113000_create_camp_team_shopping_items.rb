class CreateCampTeamShoppingItems < ActiveRecord::Migration[7.1]
  def change
    create_table :camp_team_shopping_items do |t|
      t.references :camp_team, null: false, foreign_key: true
      t.string :name, null: false
      t.string :quantity
      t.text :notes
      t.boolean :purchased, null: false, default: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
