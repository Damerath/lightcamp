class KitchenRecipeIngredientsController < KitchenRecipesController
  skip_before_action :set_recipe
  before_action :set_recipe_from_param
  before_action :require_recipe_manager

  def create
    ingredient = @recipe.ingredients.new(ingredient_params.merge(position: (@recipe.ingredients.maximum(:position) || -1) + 1))
    ingredient.save ? redirect_to(post_action_path(@recipe), notice: "Zutat wurde hinzugefügt.") : redirect_to(post_action_path(@recipe), alert: ingredient.errors.full_messages.to_sentence)
  end

  def update
    ingredient = @recipe.ingredients.find(params[:id])
    ingredient.update(ingredient_params) ? redirect_to(post_action_path(@recipe), notice: "Zutat wurde aktualisiert.") : redirect_to(post_action_path(@recipe), alert: ingredient.errors.full_messages.to_sentence)
  end

  def destroy
    ingredient = @recipe.ingredients.find(params[:id])

    if @recipe.instructions.to_s.scan(KitchenRecipe::INSTRUCTION_TOKEN_PATTERN).any? { |token| token.first.to_i == ingredient.id }
      redirect_to post_action_path(@recipe), alert: "Diese Zutat wird noch in der Zubereitung verwendet und kann nicht geloescht werden."
      return
    end

    ingredient.destroy
    redirect_to post_action_path(@recipe), notice: "Zutat wurde entfernt."
  end

  private
  def set_recipe_from_param = @recipe = KitchenRecipe.find(params[:kitchen_recipe_id])
  def ingredient_params = params.require(:kitchen_recipe_ingredient).permit(:amount, :unit, :name)
end
