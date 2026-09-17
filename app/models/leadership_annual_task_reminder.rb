class LeadershipAnnualTaskReminder < ApplicationRecord
  belongs_to :leadership_annual_task
  has_many :reminder_deliveries, class_name: "LeadershipAnnualTaskReminderDelivery", dependent: :destroy

  validates :days_before, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 365 }
  validates :days_before, uniqueness: { scope: :leadership_annual_task_id }

  scope :ordered, -> { order(days_before: :desc, id: :asc) }

  def label
    days_before.zero? ? "Am Stichtag" : "#{days_before} Tage vorher"
  end
end
