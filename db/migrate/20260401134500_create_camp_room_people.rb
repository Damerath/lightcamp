class CreateCampRoomPeople < ActiveRecord::Migration[7.1]
  def change
    create_table :camp_room_people do |t|
      t.references :camp, null: false, foreign_key: true
      t.string :name, null: false
      t.string :kind, null: false
      t.text :notes
      t.references :camp_sleeping_place, foreign_key: true
      t.references :related_camp_application, foreign_key: { to_table: :camp_applications }

      t.timestamps
    end
  end
end
