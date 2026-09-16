require "test_helper"

class KitchenRecipesHelperTest < ActionView::TestCase
  test "renders an ingredient token as scalable recipe text" do
    recipe = KitchenRecipe.create!(title: "Kartoffelsuppe", base_servings: 40)
    ingredient = recipe.ingredients.create!(amount: 2.5, unit: "kg", name: "Kartoffeln", position: 0)
    recipe.update!(instructions: "Verwende [[ingredient:#{ingredient.id}:full]].")

    rendered = render_recipe_instructions(recipe)

    assert_includes rendered, "2.5 kg Kartoffeln"
    assert_includes rendered, 'data-recipe-scaler-target="token"'
    assert_not_includes rendered, "<p>"
  end
end
