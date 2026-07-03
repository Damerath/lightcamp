class NotificationDelivery < ApplicationRecord
  enum :channel_kind, { in_app: 0, email: 1 }, prefix: true
  enum :status, { created: 0, attempted: 1, delivered: 2, failed: 3 }, prefix: true

  belongs_to :notification_event
  belongs_to :user

  validates :title, :body, presence: true

  scope :in_app_visible, -> { channel_kind_in_app.where(dismissed_at: nil).order(created_at: :desc) }
  scope :unread, -> { where(read_at: nil) }

  def unread?
    read_at.nil?
  end

  def dismissed?
    dismissed_at.present?
  end

  def mark_read!
    return if read_at.present?

    update!(read_at: Time.current)
  end

  def dismiss!
    timestamp = Time.current
    update!(read_at: read_at || timestamp, dismissed_at: timestamp)
  end
end
