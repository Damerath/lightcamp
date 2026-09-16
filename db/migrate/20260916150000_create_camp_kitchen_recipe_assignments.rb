class CreateCampKitchenRecipeAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :camp_kitchen_recipe_assignments do |t|
      t.references :camp_kitchen_day_plan, null: false, foreign_key: true, index: { name: "index_kitchen_recipe_assignments_on_day_plan" }
      t.references :kitchen_recipe, null: false, foreign_key: true
      t.string :meal_slot, null: false
      t.timestamps
    end

    add_index :camp_kitchen_recipe_assignments, %i[camp_kitchen_day_plan_id meal_slot kitchen_recipe_id], unique: true, name: "index_kitchen_recipe_assignments_uniqueness"
  end
end
