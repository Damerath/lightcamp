class CreateKitchenRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :kitchen_recipes do |t|
      t.string :title, null: false
      t.string :category
      t.integer :base_servings, null: false
      t.text :instructions, null: false, default: ""
      t.timestamps
    end

    create_table :kitchen_recipe_ingredients do |t|
      t.references :kitchen_recipe, null: false, foreign_key: true
      t.decimal :amount, null: false, precision: 10, scale: 3
      t.string :unit, null: false
      t.string :name, null: false
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
