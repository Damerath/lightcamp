class AddLabelToCampProgramWeekDays < ActiveRecord::Migration[7.1]
  def change
    add_column :camp_program_week_days, :label, :string
  end
end
