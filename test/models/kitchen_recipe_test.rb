require "test_helper"

class KitchenRecipeTest < ActiveSupport::TestCase
  test "scales an ingredient amount for the requested number of servings" do
    recipe = KitchenRecipe.create!(title: "Kartoffelsuppe", base_servings: 40)
    ingredient = recipe.ingredients.create!(amount: 2.5, unit: "kg", name: "Kartoffeln", position: 0)

    assert_equal BigDecimal("1.25"), ingredient.scaled_amount(20)
  end

  test "rejects instructions that reference an ingredient from another recipe" do
    recipe = KitchenRecipe.create!(title: "Kartoffelsuppe", base_servings: 40)
    other_recipe = KitchenRecipe.create!(title: "Gemuesesuppe", base_servings: 40)
    other_ingredient = other_recipe.ingredients.create!(amount: 2, unit: "kg", name: "Karotten", position: 0)

    recipe.instructions = "Dazu [[ingredient:#{other_ingredient.id}:full]] geben."

    assert_not recipe.valid?
    assert_includes recipe.errors[:instructions], "enthaelt eine nicht vorhandene Zutat"
  end
end
