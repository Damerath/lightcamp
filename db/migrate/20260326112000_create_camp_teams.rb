class CreateCampTeams < ActiveRecord::Migration[7.1]
  def up
    create_table :camp_teams do |t|
      t.references :camp, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :capacity, null: false, default: 0
      t.integer :male_slots, null: false, default: 0
      t.integer :female_slots, null: false, default: 0
      t.integer :responsible_slots, null: false, default: 0
      t.integer :position, null: false, default: 0
      t.timestamps
    end

    add_index :camp_teams, [:camp_id, :name], unique: true

    say_with_time "Create default teams for existing camps" do
      Camp.reset_column_information
      CampTeam.reset_column_information

      Camp.find_each do |camp|
        CampTeam::DEFAULT_TEAM_CONFIGS.each_with_index do |attributes, index|
          CampTeam.find_or_create_by!(camp_id: camp.id, name: attributes[:name]) do |team|
            team.capacity = attributes[:capacity]
            team.male_slots = attributes.fetch(:male_slots, 0)
            team.female_slots = attributes.fetch(:female_slots, 0)
            team.responsible_slots = attributes.fetch(:responsible_slots, 0)
            team.position = index
          end
        end
      end
    end
  end

  def down
    drop_table :camp_teams
  end
end
