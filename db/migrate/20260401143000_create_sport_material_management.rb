class CreateSportMaterialManagement < ActiveRecord::Migration[7.1]
  class MigrationTeamTemplate < ApplicationRecord
    self.table_name = "team_templates"
  end

  class MigrationTeamTemplateSportMaterialItem < ApplicationRecord
    self.table_name = "team_template_sport_material_items"
  end

  DEFAULT_SPORT_MATERIALS = [
    ["Armbrust", "1x", "S2"],
    ["Bolzen", "9 Stk.", "S2"],
    ["Sehnen", "4x", "S2"],
    ["Wasserbomben Schleuder", "1x", "S2"],
    ["Eroberung Kanaans (Peters spiel)", "1 Spiel vollständig", "S3"],
    ["Springseil", "1x", "S3"],
    ["Gewichte", "Verschiedene", "S3"],
    ["Peters neues Spiel", "1x", "S3"],
    ["Slackline", "1x", "S4"],
    ["Flag Football", "50/50", "S4"],
    ["Gürtel", "100x", "S4"],
    ["Schwamm", "Ca 15x", "S4"],
    ["Baseball Ball", "3x", "S5"],
    ["Wäscheklammern", "(Genug)", "S5"],
    ["Kirschkerne", "1 Tüte", "S5"],
    ["Luftpumpe", "3x", "S5"],
    ["Absperrband", "Volle Rolle + Reste", "S5"],
    ["Schwimmflossen", "4 paar", "S6"],
    ["Taucherbrille", "6x", "S6"],
    ["Holzkegel", "10x", "S6"],
    ["Plastik Kegel", "8x", "S6"],
    ["Kugeln", "5x", "S6"],
    ["Bogen", "3x", "S7"],
    ["Sehnen", "2x", "S7"],
    ["Pfeile", "9x", "S7"],
    ["Knicklichter", "100x (bunt)", "S8"],
    ["Wäscheleine", "Ca. 10m", "S8"],
    ["Tischtennisbälle", "50x", "S8"],
    ["Tennisbälle", "20x", "S8"],
    ["Blaue Schnurr", "Ca. 10m + Reste", "S8"],
    ["Strohband", "Viele Reste", "S8"],
    ["Klebeband", "Reste", "S8"],
    ["Golfbälle", "24x", "S8"],
    ["Murmeln", "Kiste", "S8"],
    ["Knobelbälle", "6x", "S8"],
    ["Spülmittel", "3,5x", "S8"],
    ["Timer", "7x", "S8"],
    ["Stoppuhr", "3x", "S8"],
    ["Pfeifen", "7x", "S8"],
    ["Luftballons", "Reste", "S8"],
    ["Wasserbomben", "Reste", "S8"],
    ["Ballonluftpumpe", "2x", "S8"],
    ["Wasserpistole", "2x", "S8"],
    ["Klemmbretter", "5x", "S8"],
    ["Klebebänder gelb", "22x", "S8"],
    ["Pfanne klein", "2x", "S8"],
    ["Schüsseln", "3x", "S9"],
    ["Eimer", "21 groß / 2 kleine", "S9"],
    ["Pylonen / Hüttchen", "6 groß / 6 klein", "S10"],
    ["Große Bases (Grün)", "4x", "S10"],
    ["Kleine Bases (weiß)", "4x", "S10"],
    ["Plane", "1x", "S10"],
    ["Leibchen", "", "S10"],
    ["Bällebad", "2 Kisten", "S11"],
    ["Dosenstelzen", "10 paar", "S12"],
    ["Frisbee", "6x", "S12"],
    ["Riesen Ligretto", "1 Spiel vollständig", "S12"],
    ["Knotenseile (Hundeknochen)", "Ca 8", "S12"],
    ["Golfschläger", "1x", "S13"],
    ["Stöcke", "12x", "S13"],
    ["Baseball Schläger", "2x", "S13"],
    ["Hockeyschläger", "10/10 (rot/gelb)", "S14"],
    ["Cricketschläger", "2x", "S14"],
    ["Cricketbälle", "4x", "S14"],
    ["Gruppenski", "3 paar", "S15"],
    ["Hulla Reifen", "3x", "S15"],
    ["Jugger", "1 Spiel vollständig", "S16"],
    ["Fußball", "3x", "Netz"],
    ["Basketball", "2x", "Netz"],
    ["Volleyball", "4x", "Netz"],
    ["Ballnetz", "1x", "Wand"],
    ["Spikeball", "2x", ""]
  ].freeze

  def up
    create_table :team_template_sport_material_items do |t|
      t.references :team_template, null: false, foreign_key: true
      t.string :name, null: false
      t.string :quantity, null: false, default: ""
      t.string :storage_location, null: false, default: ""
      t.integer :position, null: false, default: 0
      t.timestamps
    end

    add_index :team_template_sport_material_items, [:team_template_id, :position], name: "index_template_sport_materials_on_template_and_position"

    create_table :camp_sport_material_items do |t|
      t.references :camp_team, null: false, foreign_key: true
      t.string :name, null: false
      t.string :quantity, null: false, default: ""
      t.string :storage_location, null: false, default: ""
      t.integer :position, null: false, default: 0
      t.timestamps
    end

    add_index :camp_sport_material_items, [:camp_team_id, :position], name: "index_camp_sport_materials_on_team_and_position"

    create_table :camp_sport_material_changes do |t|
      t.references :camp_team, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :actor_name, null: false, default: ""
      t.string :material_name, null: false
      t.string :change_type, null: false
      t.text :change_summary, null: false
      t.timestamps
    end

    add_index :camp_sport_material_changes, [:camp_team_id, :created_at], name: "index_camp_sport_material_changes_on_team_and_created_at"

    populate_default_sport_materials!
  end

  def down
    drop_table :camp_sport_material_changes
    drop_table :camp_sport_material_items
    drop_table :team_template_sport_material_items
  end

  private

  def populate_default_sport_materials!
    sport_template = MigrationTeamTemplate.find_or_create_by!(name: "Sport")

    DEFAULT_SPORT_MATERIALS.each_with_index do |(name, quantity, storage_location), index|
      MigrationTeamTemplateSportMaterialItem.find_or_create_by!(
        team_template_id: sport_template.id,
        position: index
      ) do |item|
        item.name = name
        item.quantity = quantity
        item.storage_location = storage_location
      end
    end
  end
end
