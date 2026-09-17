class LeadershipList < ApplicationRecord
  has_many :items, class_name: "LeadershipListItem", dependent: :destroy

  validates :title, presence: true

  scope :ordered, -> { order(:title, :id) }
end
