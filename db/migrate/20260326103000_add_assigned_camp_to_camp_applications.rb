class AddAssignedCampToCampApplications < ActiveRecord::Migration[7.1]
  def change
    add_reference :camp_applications, :assigned_camp, foreign_key: { to_table: :camps }
  end
end
