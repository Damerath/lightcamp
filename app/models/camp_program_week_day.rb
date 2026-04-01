class CampProgramWeekDay < ApplicationRecord
  DAY_LABELS = {
    "monday" => "Montag",
    "tuesday" => "Dienstag",
    "wednesday" => "Mittwoch",
    "thursday" => "Donnerstag",
    "friday" => "Freitag",
    "saturday" => "Samstag",
    "sunday" => "Sonntag"
  }.freeze

  belongs_to :camp_team
  has_many :camp_program_week_blocks, dependent: :destroy

  before_validation :assign_day_key_from_date

  validates :day_key, presence: true, inclusion: { in: DAY_LABELS.keys }
  validates :label, length: { maximum: 80 }, allow_blank: true
  validates :planned_on, presence: true, uniqueness: { scope: :camp_team_id }
  validates :mode, presence: true, inclusion: { in: %w[default_plan custom] }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :id) }

  def day_label
    return I18n.l(planned_on, format: "%A, %d.%m.%Y") if planned_on.present?

    DAY_LABELS.fetch(day_key, day_key.humanize)
  end

  def default_plan?
    mode == "default_plan"
  end

  def custom?
    mode == "custom"
  end

  private

  def assign_day_key_from_date
    return if planned_on.blank?

    self.day_key = planned_on.strftime("%A").downcase
  end
end
