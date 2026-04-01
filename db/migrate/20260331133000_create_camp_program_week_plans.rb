class CreateCampProgramWeekPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :camp_program_week_days do |t|
      t.references :camp_team, null: false, foreign_key: true
      t.string :day_key, null: false
      t.string :mode, null: false, default: "default_plan"
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :camp_program_week_days, [:camp_team_id, :day_key], unique: true

    create_table :camp_program_week_blocks do |t|
      t.references :camp_program_week_day, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :starts_at_minutes, null: false
      t.integer :position, null: false, default: 0
      t.boolean :visible_to_others, null: false, default: true

      t.timestamps
    end
  end
end
