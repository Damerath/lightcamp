class CreateMedicalSupplyManagement < ActiveRecord::Migration[7.1]
  class MigrationMedicalSupplyItem < ApplicationRecord
    self.table_name = "medical_supply_items"
  end

  DEFAULT_MEDICAL_SUPPLIES = [
    ["Medikamente", "Schmerzen", "Paracetamol ADGC 500mg", "", "10.2025", "", false, false],
    ["Medikamente", "Schmerzen", "Ibuprofen akut 400g", "", "06.2026", "", false, false],
    ["Medikamente", "Schmerzen", "Aspirin Plus C", "", "05.2026", "", false, false],
    ["Medikamente", "Allergie", "Cetirizin Vividrin10mg", "", "08.2024", "", true, false],
    ["Medikamente", "Übelkeit, Erbrechen", "Reisetabletten 50g", "", "", "", true, false],
    ["Medikamente", "Magen-Darm-Beschwerden", "Iberogast", "", "10.2024", "", true, false],
    ["Medikamente", "Magen-Darm-Beschwerden", "Vomacur", "", "09.2024", "", true, false],
    ["Medikamente", "Magen-Darm-Beschwerden", "Vomex A", "", "", "", true, false],
    ["Medikamente", "Diarrhö", "Loperamid 2mg", "", "07.2026", "", false, false],
    ["Medikamente", "Diarrhö", "Imodium akut 2mg", "", "", "", true, false],
    ["Medikamente", "Diarrhö", "Perenterol Junior 250mg", "", "08.2026", "Ab 12 Jahre", false, false],
    ["Medikamente", "Elektrolytmangel", "Elotran Beutel", "", "", "", true, false],
    ["Medikamente", "Elektrolytmangel", "Magnesiumbrausetabletten", "", "", "", true, false],
    ["Medikamente", "Menstruationsbeschwerden", "Buscupan 10mg", "", "10.2025", "", false, false],
    ["Medikamente", "", "Augentropfen Artelac Splash", "", "05.2025", "", false, false],
    ["Medikamente", "", "Nasentropfen Otriven", "", "", "", true, false],
    ["Medikamente", "", "Ohrentropfen Otalgan 10g", "", "", "", true, false],
    ["Medikamente", "Husten", "ACC Akut 600mg", "", "01.2027", "", false, false],
    ["Medikamente", "Husten", "Hustenbonbons", "", "", "", false, false],
    ["Medikamente", "Blutzucker", "Traubenzucker", "", "", "", false, false],
    ["Medikamente", "Halsschmerzen", "Dobendan Direkt", "", "08.2026", "", false, false],
    ["Salben", "Wundsalbe", "PVP-Salbe", "", "06.2024", "", true, true],
    ["Salben", "Wundsalbe", "Octenisept-Gel", "", "02.2025", "", true, true],
    ["Salben", "Wundsalbe", "Bepanthen", "", "03.2026", "", true, true],
    ["Salben", "Allergie, Verbrennung, Stiche", "Fenistil", "", "11.2024", "", true, true],
    ["Salben", "Schmerzen, Schwellungen, Entzündungen", "Voltaren", "", "", "", true, false],
    ["Salben", "Schmerzen, Schwellungen, Entzündungen", "Diclac", "", "10.2026", "", true, true],
    ["Salben", "Augensalbe", "Bepanthen", "", "02.2025", "", true, false],
    ["Salben", "Lippensalbe", "Bepanthen", "", "", "", true, false],
    ["Salben", "Lippensalbe", "Acic Lippenherpes", "", "11.2026", "", true, true],
    ["Salben", "Entzündung im Mund", "Kamistad Gel", "", "09.2028", "", false, false],
    ["Werkzeuge", "", "Zeckenzange", "2x", "", "", true, false],
    ["Werkzeuge", "", "Zeckenkarte", "1x", "", "", false, false],
    ["Werkzeuge", "", "Nagelschere", "1x", "", "", false, false],
    ["Werkzeuge", "", "Verbandschere", "2x", "", "", false, false],
    ["Werkzeuge", "", "Pinzette", "1x", "", "", false, false],
    ["Werkzeuge", "", "Nadel", "1 Pck.", "", "", false, false],
    ["Verbandsmaterial", "Hautdesinfektion", "Octenisept-Spray", "", "", "", false, false],
    ["Verbandsmaterial", "Handdesinfektion", "Sterillium", "", "", "", false, false],
    ["Verbandsmaterial", "Wundversorgung", "Sterile Mullbinden", "8,5 x 5, 10x10", "", "", false, false],
    ["Verbandsmaterial", "Wundversorgung", "Unsterile Mullbinden", "", "", "", false, false],
    ["Verbandsmaterial", "Wundversorgung", "Elastische Fixierbinde (Steril)", "", "", "Evtl. nachkaufen", false, false],
    ["Verbandsmaterial", "Wundversorgung", "Elastische Mittelzugbinde", "", "", "", false, false],
    ["Verbandsmaterial", "Wundversorgung", "Sterile Kompressen", "", "", "", false, false],
    ["Verbandsmaterial", "Wundversorgung", "Unsterile Kompressen", "", "", "Nachkaufen", false, false],
    ["Verbandsmaterial", "Wundversorgung", "Verbandspflaster", "Größen: 5x7, 10x8, 115x10", "", "", false, false],
    ["Verbandsmaterial", "Wundversorgung", "Classic Wundpflaster", "", "", "", false, false],
    ["Verbandsmaterial", "Wundversorgung", "Klebestreifen", "", "", "", false, false],
    ["Verbandsmaterial", "Wundversorgung", "Einmalhandschuhe", "Größe: M, S", "", "", false, false],
    ["Verbandsmaterial", "", "Sicherheitsnadeln", "1 Pck.", "", "", false, false],
    ["Verbandsmaterial", "", "Nageletui", "", "", "", true, false],
    ["Sonstiges", "Bauchschmerzen", "Wärmflasche", "3x", "", "", false, false],
    ["Sonstiges", "Prellungen, Stiche, …", "Kühlpacks", "26x", "", "", false, false],
    ["Sonstiges", "Schnupfen, Nasenbluten, …", "Taschentücher", "2x", "", "", false, false],
    ["Sonstiges", "Fieber", "Fieberthermometer", "1x", "", "", false, false],
    ["Sonstiges", "Sonnenschutz", "Sonnencreme", "2x", "", "", false, false],
    ["Sonstiges", "Sonnenschutz", "After Sun", "1x", "", "", false, false],
    ["Sonstiges", "Sonnenschutz", "Kopftücher", "16x", "", "", false, false],
    ["Sonstiges", "Sonnenschutz", "Handtücher", "2x", "", "", false, false],
    ["Sonstiges", "Wanderung", "Erste Hilfe Set - klein", "4x", "", "", false, false],
    ["Sonstiges", "Wanderung", "Erste Hilfe Set - groß", "1x", "", "", false, false],
    ["Sonstiges", "Unterkühlung, schwere Verbrennung/Verletzung, …", "Rettungsdecke", "1x", "", "", false, false],
    ["Sonstiges", "Kleidung", "Shorts", "2x", "", "", false, false],
    ["Sonstiges", "Muskel- und Gelenkschmerzen, …", "Elastisches Tape", "", "", "", true, false],
    ["Sonstiges", "Muskel- und Gelenkschmerzen, …", "Selbsthaftender Fingerverband (Tape)", "2,5 x 4,5cm", "", "", false, false],
    ["Sonstiges", "Hygieneartikel", "Binden", "5x", "", "", false, false],
    ["Sonstiges", "Hygieneartikel", "Zahnbürsten", "4x", "", "", false, false]
  ].freeze

  def up
    create_table :medical_supply_items do |t|
      t.string :category, null: false
      t.string :usage_purpose, null: false, default: ""
      t.string :name, null: false
      t.string :quantity, null: false, default: ""
      t.string :expires_on_label, null: false, default: ""
      t.text :notes, null: false, default: ""
      t.boolean :missing, null: false, default: false
      t.boolean :opened, null: false, default: false
      t.integer :position, null: false, default: 0
      t.timestamps
    end

    add_index :medical_supply_items, [:category, :position], name: "idx_med_supply_items_on_category_and_position"

    create_table :medical_supply_changes do |t|
      t.references :user, foreign_key: true
      t.string :actor_name, null: false, default: ""
      t.string :item_name, null: false
      t.string :change_type, null: false
      t.text :change_summary, null: false
      t.timestamps
    end

    add_index :medical_supply_changes, :created_at

    DEFAULT_MEDICAL_SUPPLIES.each_with_index do |(category, usage_purpose, name, quantity, expires_on_label, notes, missing, opened), index|
      MigrationMedicalSupplyItem.create!(
        category: category,
        usage_purpose: usage_purpose,
        name: name,
        quantity: quantity,
        expires_on_label: expires_on_label,
        notes: notes,
        missing: missing,
        opened: opened,
        position: index
      )
    end
  end

  def down
    drop_table :medical_supply_changes
    drop_table :medical_supply_items
  end
end
