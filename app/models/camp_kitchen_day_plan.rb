class CampKitchenDayPlan < ApplicationRecord
  belongs_to :camp_team
  has_many :recipe_assignments, class_name: "CampKitchenRecipeAssignment", dependent: :destroy

  validates :planned_on, presence: true, uniqueness: { scope: :camp_team_id }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :planned_on, :id) }

  def day_label
    I18n.l(planned_on, format: "%A, %d.%m.%Y")
  end
end
