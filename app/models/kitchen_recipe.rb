class KitchenRecipe < ApplicationRecord
  INSTRUCTION_TOKEN_PATTERN = /\[\[ingredient:(\d+):(full|amount)\]\]/
  MEAL_CATEGORIES = ["Frühstück", "Mittagessen", "Abendessen", "Snack", "Dessert"].freeze

  has_many :ingredients, class_name: "KitchenRecipeIngredient", dependent: :destroy

  validates :title, presence: true
  validates :base_servings, numericality: { only_integer: true, greater_than: 0 }
  validates :category, inclusion: { in: MEAL_CATEGORIES }, allow_nil: true
  validates :effort_level, inclusion: { in: 1..5 }
  validate :instruction_tokens_reference_recipe_ingredients

  scope :ordered, -> { order(:category, :title) }

  private

  # Editor buttons only create tokens for this recipe's ingredients.
  # Rejecting unknown IDs prevents broken amounts in rendered instructions.
  def instruction_tokens_reference_recipe_ingredients
    ingredient_ids = instructions.to_s.scan(INSTRUCTION_TOKEN_PATTERN).map { |match| match.first.to_i }.uniq
    return if ingredient_ids.empty?

    missing_ids = ingredient_ids - ingredients.where(id: ingredient_ids).pluck(:id)
    errors.add(:instructions, "enthaelt eine nicht vorhandene Zutat") if missing_ids.any?
  end
end
