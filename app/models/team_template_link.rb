class TeamTemplateLink < ApplicationRecord
  belongs_to :team_template

  validates :title, :url, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :title) }
end
