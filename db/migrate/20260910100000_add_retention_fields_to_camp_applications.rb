class AddRetentionFieldsToCampApplications < ActiveRecord::Migration[7.1]
  def change
    change_column_null :camp_applications, :user_id, true
    add_column :camp_applications, :archived_display_name, :string
    add_column :camp_applications, :health_data_deleted_at, :datetime
    add_column :camp_applications, :anonymized_at, :datetime
  end
end
