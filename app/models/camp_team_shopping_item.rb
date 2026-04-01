class CampTeamShoppingItem < ApplicationRecord
  belongs_to :camp_team

  validates :name, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :created_at) }
end
