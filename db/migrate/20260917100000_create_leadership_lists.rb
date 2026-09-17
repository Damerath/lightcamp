class CreateLeadershipLists < ActiveRecord::Migration[7.1]
  def change
    create_table :leadership_lists do |t|
      t.string :title, null: false
      t.text :description
      t.timestamps
    end

    create_table :leadership_list_items do |t|
      t.references :leadership_list, null: false, foreign_key: true
      t.string :text, null: false
      t.integer :position, null: false, default: 0
      t.boolean :completed, null: false, default: false
      t.datetime :completed_at
      t.timestamps
    end

    add_index :leadership_list_items, %i[leadership_list_id completed position], name: "index_leadership_list_items_on_list_completion_position"
  end
end
