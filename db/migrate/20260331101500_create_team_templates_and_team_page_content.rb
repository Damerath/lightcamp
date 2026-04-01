class CreateTeamTemplatesAndTeamPageContent < ActiveRecord::Migration[7.1]
  DEFAULT_TEAM_NAMES = [
    "Freizeitleiter",
    "Programmleiter",
    "Prediger",
    "Gruppenleiter",
    "Sport",
    "DIY",
    "Küche",
    "Fotograf",
    "Videograf",
    "Techniker",
    "Spüli",
    "Musikverantwortlicher",
    "Krankenpfleger/-in",
    "Campstory"
  ].freeze

  class MigrationTeamTemplate < ApplicationRecord
    self.table_name = "team_templates"
  end

  class MigrationCampTeam < ApplicationRecord
    self.table_name = "camp_teams"
  end

  def up
    create_table :team_templates do |t|
      t.string :name, null: false
      t.text :description
      t.timestamps
    end

    add_index :team_templates, :name, unique: true

    change_table :camp_teams do |t|
      t.references :team_template, foreign_key: true
      t.datetime :next_internal_meeting_at
    end

    create_table :camp_team_links do |t|
      t.references :camp_team, null: false, foreign_key: true
      t.string :title, null: false
      t.string :url, null: false
      t.integer :position, null: false, default: 0
      t.timestamps
    end

    create_table :camp_team_todos do |t|
      t.references :camp_team, null: false, foreign_key: true
      t.string :title, null: false
      t.boolean :completed, null: false, default: false
      t.integer :position, null: false, default: 0
      t.timestamps
    end

    team_names = (DEFAULT_TEAM_NAMES + MigrationCampTeam.distinct.order(:name).pluck(:name)).uniq

    team_names.each do |name|
      MigrationTeamTemplate.find_or_create_by!(name: name)
    end

    MigrationCampTeam.reset_column_information

    MigrationCampTeam.find_each do |camp_team|
      template = MigrationTeamTemplate.find_by(name: camp_team.name)
      camp_team.update_columns(team_template_id: template&.id)
    end
  end

  def down
    drop_table :camp_team_todos
    drop_table :camp_team_links
    remove_reference :camp_teams, :team_template, foreign_key: true
    remove_column :camp_teams, :next_internal_meeting_at
    drop_table :team_templates
  end
end
