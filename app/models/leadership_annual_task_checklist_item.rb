class LeadershipAnnualTaskChecklistItem < ApplicationRecord
  belongs_to :leadership_annual_task

  validates :text, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :unfinished, -> { where(completed: false).order(:position, :id) }
  scope :completed_recently, -> { where(completed: true).order(completed_at: :desc, id: :desc) }
end
