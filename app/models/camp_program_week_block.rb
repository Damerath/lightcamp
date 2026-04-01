class CampProgramWeekBlock < ApplicationRecord
  belongs_to :camp_program_week_day

  validates :title, presence: true
  validates :color, presence: true, inclusion: { in: CampProgramBlock::COLOR_THEMES.keys }
  validates :starts_at_minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24 * 60 }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :starts_at_minutes, :created_at) }

  def start_hour
    format("%02d", starts_at_minutes / 60)
  end

  def start_minute
    format("%02d", starts_at_minutes % 60)
  end

  def starts_at_label
    "#{start_hour}:#{start_minute}"
  end

  def color_card_classes
    CampProgramBlock::COLOR_THEMES.fetch(color, CampProgramBlock::COLOR_THEMES["blue"])[:card]
  end

  def normalized_title
    title.to_s.squish.downcase
  end
end
