class CreateCampSleepingPlacesAndAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :camp_sleeping_places do |t|
      t.references :camp, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :capacity, null: false, default: 1
      t.string :details
      t.integer :position, null: false, default: 0
      t.boolean :custom, null: false, default: false

      t.timestamps
    end

    add_index :camp_sleeping_places, [:camp_id, :name], unique: true

    add_reference :camp_applications, :camp_sleeping_place, foreign_key: true
  end
end
