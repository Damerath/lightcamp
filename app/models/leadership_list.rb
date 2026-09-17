class LeadershipList < ApplicationRecord
  has_many :items, class_name: "LeadershipListItem", dependent: :destroy

  validates :title, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :id) }
end
