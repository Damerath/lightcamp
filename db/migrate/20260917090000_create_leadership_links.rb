class CreateLeadershipLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :leadership_links do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
