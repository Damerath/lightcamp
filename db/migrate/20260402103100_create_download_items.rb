class CreateDownloadItems < ActiveRecord::Migration[7.1]
  def change
    create_table :download_items do |t|
      t.string :title, null: false
      t.text :description
      t.integer :scope_kind, null: false, default: 0
      t.references :team_template, foreign_key: true
      t.references :camp_team, foreign_key: true
      t.references :uploader, foreign_key: { to_table: :users }
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :download_items, [:scope_kind, :position], name: :idx_download_items_on_scope_and_position
  end
end
