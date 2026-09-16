class KitchenRecipesController < ApplicationController
  include CampTeamAccess
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_kitchen_access
  before_action :set_recipe, only: %i[show update destroy]
  before_action :require_recipe_manager, only: %i[create update destroy]
  def index
    redirect_to workspace_recipe_book_path
  end

  def show
    redirect_to workspace_recipe_book_path(@recipe)
  end

  def create
    recipe = KitchenRecipe.new(recipe_params)
    if recipe.save
      redirect_to post_action_path(recipe), notice: "Rezept wurde angelegt. Jetzt kannst du Zutaten und Zubereitung ergänzen."
    else
      redirect_to post_action_path, alert: recipe.errors.full_messages.to_sentence
    end
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to post_action_path(@recipe), notice: "Rezept wurde aktualisiert."
    else
      redirect_to post_action_path(@recipe), alert: @recipe.errors.full_messages.to_sentence
    end
  end

  def destroy
    @recipe.destroy
    redirect_to post_action_path, notice: "Rezept wurde gelöscht."
  end

  private
  def set_recipe = @recipe = KitchenRecipe.find(params[:id])
  def recipe_params = params.require(:kitchen_recipe).permit(:title, :category, :base_servings, :effort_level, :instructions)

  def workspace_recipe_book_path(recipe = nil)
    options = { section: "recipe_book" }
    options[:recipe_id] = recipe.id if recipe.present?

    if request.path.start_with?("/admin/")
      admin_camp_team_page_path(@camp, @camp_team, options)
    else
      camp_team_page_path(@camp, @camp_team, options)
    end
  end

  def post_action_path(recipe = nil)
    return workspace_recipe_book_path(recipe) if params[:team_view] == "1"

    recipe.present? ? workspace_recipe_book_path(recipe) : workspace_recipe_book_path
  end
  def require_kitchen_access
    return if @camp_team.kitchen_team? && (current_user&.management? || current_user&.camp_applications&.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids))
    redirect_to camps_path, alert: "Kein Zugriff auf das Rezeptbuch."
  end
  def require_recipe_manager
    redirect_to workspace_recipe_book_path, alert: "Nur Küchenverantwortliche dürfen Rezepte bearbeiten." unless @camp_team.kitchen_recipe_manager?(current_user)
  end
end
