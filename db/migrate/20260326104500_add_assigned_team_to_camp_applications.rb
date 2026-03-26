class AddAssignedTeamToCampApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :camp_applications, :assigned_team, :string
  end
end
