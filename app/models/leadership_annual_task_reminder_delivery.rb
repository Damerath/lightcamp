class LeadershipAnnualTaskReminderDelivery < ApplicationRecord
  belongs_to :leadership_annual_task
  belongs_to :leadership_annual_task_reminder, inverse_of: :reminder_deliveries

  validates :due_on, presence: true
end
