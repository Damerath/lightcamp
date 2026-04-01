class TeamTemplateSportMaterialItem < ApplicationRecord
  belongs_to :team_template

  validates :name, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :name, :id) }
end
