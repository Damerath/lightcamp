class CreateCampProgramBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :camp_program_blocks do |t|
      t.references :camp_team, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :starts_at_minutes, null: false
      t.integer :position, null: false, default: 0
      t.boolean :visible_to_others, null: false, default: true

      t.timestamps
    end
  end
end
