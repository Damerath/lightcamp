class RemoveDayKeyUniqueIndexFromCampProgramWeekDays < ActiveRecord::Migration[7.1]
  def change
    remove_index :camp_program_week_days, name: "index_camp_program_week_days_on_camp_team_id_and_day_key"
  end
end
