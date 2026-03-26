class AddDetailsToCampApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :camp_applications, :uncertain_until, :date
    add_column :camp_applications, :team_preference, :string
    add_column :camp_applications, :responsible, :boolean, default: false
    add_column :camp_applications, :health_restrictions, :boolean, default: false
    add_column :camp_applications, :health_restrictions_details, :text, default: false
  end
end
