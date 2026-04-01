class AddPlannedOnToCampProgramWeekDays < ActiveRecord::Migration[7.1]
  def change
    add_column :camp_program_week_days, :planned_on, :date
    add_index :camp_program_week_days, [:camp_team_id, :planned_on], unique: true
  end
end
