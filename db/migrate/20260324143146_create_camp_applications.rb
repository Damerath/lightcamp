class CreateCampApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :camp_applications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :year, null: false, foreign_key: true
      t.text :motivation
      t.string :commitment
      t.text :comment

      t.timestamps
    end
  end
end
