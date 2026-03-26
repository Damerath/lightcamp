class CreateCampApplicationChoices < ActiveRecord::Migration[7.1]
  def change
    create_table :camp_application_choices do |t|
      t.references :camp_application, null: false, foreign_key: true
      t.references :camp, null: false, foreign_key: true

      t.timestamps
    end
  end
end
