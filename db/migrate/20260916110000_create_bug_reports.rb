class CreateBugReports < ActiveRecord::Migration[7.1]
  def change
    create_table :bug_reports do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :category, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.string :title, null: false
      t.text :description, null: false
      t.text :page_url
      t.string :browser_details
      t.string :viewport
      t.text :admin_notes
      t.timestamps
    end

    add_index :bug_reports, [:status, :created_at]
  end
end
