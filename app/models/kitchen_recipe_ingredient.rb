class KitchenRecipeIngredient < ApplicationRecord
  belongs_to :kitchen_recipe

  validates :name, :unit, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :id) }

  def scaled_amount(servings)
    amount * BigDecimal(servings.to_s) / kitchen_recipe.base_servings
  end
end
