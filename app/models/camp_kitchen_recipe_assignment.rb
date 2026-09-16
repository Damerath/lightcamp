class CampKitchenRecipeAssignment < ApplicationRecord
  MEAL_SLOTS = %w[breakfast lunch dinner snack].freeze

  belongs_to :camp_kitchen_day_plan
  belongs_to :kitchen_recipe

  validates :meal_slot, inclusion: { in: MEAL_SLOTS }
  validates :kitchen_recipe_id, uniqueness: { scope: %i[camp_kitchen_day_plan_id meal_slot] }

  scope :ordered, -> { order(:created_at, :id) }
end
