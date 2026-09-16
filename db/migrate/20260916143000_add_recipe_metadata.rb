class AddRecipeMetadata < ActiveRecord::Migration[7.1]
  def change
    add_column :kitchen_recipes, :effort_level, :integer, null: false, default: 1
  end
end
