class AddProfileFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :gender, :string
    add_column :users, :birthdate, :date
    add_column :users, :phone, :string
    add_column :users, :first_aider, :boolean, default: false
    add_column :users, :sound_tech, :boolean, default: false
    add_column :users, :instruments, :string
    add_column :users, :other_skills, :string
  end
end
