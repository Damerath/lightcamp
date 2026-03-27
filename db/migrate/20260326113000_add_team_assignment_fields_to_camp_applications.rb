class AddTeamAssignmentFieldsToCampApplications < ActiveRecord::Migration[7.1]
  def up
    add_reference :camp_applications, :assigned_camp_team, foreign_key: { to_table: :camp_teams }
    add_column :camp_applications, :assigned_as_responsible, :boolean, default: false, null: false

    say_with_time "Backfill assigned camp teams from existing assignments" do
      CampApplication.reset_column_information
      CampTeam.reset_column_information

      CampApplication.find_each do |application|
        next if application.assigned_camp_id.blank? || application.assigned_team.blank?

        team = CampTeam.find_by(camp_id: application.assigned_camp_id, name: application.assigned_team)
        next if team.blank?

        application.update_columns(
          assigned_camp_team_id: team.id,
          assigned_as_responsible: false
        )
      end
    end
  end

  def down
    remove_column :camp_applications, :assigned_as_responsible
    remove_foreign_key :camp_applications, column: :assigned_camp_team_id
    remove_reference :camp_applications, :assigned_camp_team, index: true
  end
end
