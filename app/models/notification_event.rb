class NotificationEvent < ApplicationRecord
  belongs_to :actor, class_name: "User", optional: true
  has_many :notification_deliveries, dependent: :destroy

  validates :key, presence: true

  scope :recent_first, -> { order(created_at: :desc) }
end
