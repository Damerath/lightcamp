class AddRegistrationOpenToYears < ActiveRecord::Migration[7.1]
  def change
    add_column :years, :registration_open, :boolean, default: false
  end
end
