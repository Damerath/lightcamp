class CreateCampDiyDayPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :camp_diy_day_plans do |t|
      t.references :camp_team, null: false, foreign_key: true
      t.date :planned_on, null: false
      t.integer :position, null: false, default: 0
      t.text :general_offer
      t.text :daily_special

      t.timestamps
    end

    add_index :camp_diy_day_plans, [:camp_team_id, :planned_on], unique: true
  end
end
