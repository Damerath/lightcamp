class AddPositionToLeadershipLists < ActiveRecord::Migration[7.1]
  class MigrationLeadershipList < ActiveRecord::Base
    self.table_name = "leadership_lists"
  end

  def up
    add_column :leadership_lists, :position, :integer, null: false, default: 0
    add_index :leadership_lists, :position

    # Existing lists retain the alphabetical order that was used before sorting was added.
    MigrationLeadershipList.order(:title, :id).find_each.with_index do |leadership_list, position|
      leadership_list.update_column(:position, position)
    end
  end

  def down
    remove_index :leadership_lists, :position
    remove_column :leadership_lists, :position
  end
end
