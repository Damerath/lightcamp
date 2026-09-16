class BugReport < ApplicationRecord
  CATEGORY_LABELS = {
    "functionality" => "Funktion",
    "display" => "Darstellung",
    "data" => "Daten",
    "permission" => "Berechtigung",
    "other" => "Sonstiges"
  }.freeze
  STATUS_LABELS = {
    "reported" => "Neu",
    "in_progress" => "In Bearbeitung",
    "resolved" => "Gelöst",
    "closed" => "Geschlossen"
  }.freeze

  enum :category, { functionality: 0, display: 1, data: 2, permission: 3, other: 4 }, prefix: true
  enum :status, { reported: 0, in_progress: 1, resolved: 2, closed: 3 }, prefix: true

  belongs_to :user
  has_one_attached :screenshot

  validates :title, presence: true, length: { maximum: 160 }
  validates :description, presence: true, length: { maximum: 5_000 }
  validate :screenshot_is_supported

  def category_label
    CATEGORY_LABELS.fetch(category)
  end

  def status_label
    STATUS_LABELS.fetch(status)
  end

  private

  def screenshot_is_supported
    return unless screenshot.attached?

    unless screenshot.blob.content_type.in?(%w[image/png image/jpeg image/webp])
      errors.add(:screenshot, "muss ein PNG-, JPEG- oder WebP-Bild sein")
    end

    if screenshot.blob.byte_size > 5.megabytes
      errors.add(:screenshot, "darf maximal 5 MB gross sein")
    end
  end
end
