class CreateCampSportTournamentPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :camp_sport_tournament_plans do |t|
      t.references :camp_team, null: false, foreign_key: true, index: { unique: true }
      t.integer :start_time_minutes, null: false, default: 900
      t.integer :round_interval_minutes, null: false, default: 15
      t.string :round_note, null: false, default: "10 min Spiel, 5 min Wechsel"
      t.string :group1_name
      t.string :group2_name
      t.string :group3_name
      t.string :group4_name
      t.string :group5_name
      t.string :station1_name
      t.string :station2_name
      t.string :station3_name
      t.string :station4_name
      t.string :station5_name

      t.timestamps
    end

  end
end
