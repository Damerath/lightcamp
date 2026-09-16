module KitchenRecipesHelper
  def recipe_effort_color_class(recipe)
    case recipe.effort_level
    when 1, 2 then "bg-green-500"
    when 3 then "bg-yellow-500"
    when 4 then "bg-orange-500"
    else "bg-red-500"
    end
  end

  def render_recipe_instructions(recipe)
    ingredients = recipe.ingredients.index_by(&:id)
    parts = recipe.instructions.to_s.split(KitchenRecipe::INSTRUCTION_TOKEN_PATTERN)
    output = parts.each_with_index.map do |part, index|
      if index % 3 == 1
        ingredient = ingredients[part.to_i]
        kind = parts[index + 1]
        ingredient ? content_tag(:span, kind == "amount" ? ingredient.amount : "#{ingredient.amount} #{ingredient.unit} #{ingredient.name}", data: { recipe_scaler_target: "token", amount: ingredient.amount, unit: ingredient.unit, name: ingredient.name, kind: kind }) : "[fehlende Zutat]"
      elsif index % 3 == 2
        nil
      else
        render_instruction_text(part)
      end
    end
    safe_join(output.compact)
  end

  private

  # Keep text surrounding an inserted ingredient in the same sentence while
  # still escaping user input and preserving line breaks from the editor.
  def render_instruction_text(text)
    safe_join(text.split(/(\r?\n)/).map { |part| part.match?(/\r?\n/) ? tag.br : ERB::Util.html_escape(part) })
  end
end
