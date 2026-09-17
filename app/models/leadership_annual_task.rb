class LeadershipAnnualTask < ApplicationRecord
  belongs_to :responsible_user, class_name: "User", inverse_of: :leadership_annual_tasks

  has_many :checklist_items, class_name: "LeadershipAnnualTaskChecklistItem", dependent: :destroy
  has_many :reminders, class_name: "LeadershipAnnualTaskReminder", dependent: :destroy
  has_many :reminder_deliveries, class_name: "LeadershipAnnualTaskReminderDelivery", dependent: :destroy

  validates :title, presence: true
  validates :due_month, :reactivation_month, inclusion: { in: 1..12 }
  validates :due_day, :reactivation_day, inclusion: { in: 1..31 }
  validate :dates_are_valid_calendar_days
  validate :responsible_user_is_management

  scope :active, -> { where(active: true) }
  scope :open, -> { where(completed: false) }
  scope :completed_recently, -> { where(completed: true).order(completed_at: :desc, id: :desc) }

  def due_on(year)
    Date.new(year, due_month, due_day)
  rescue Date::Error
    nil
  end

  def reactivation_on(year)
    Date.new(year, reactivation_month, reactivation_day)
  rescue Date::Error
    nil
  end

  def current_cycle_reactivation_on(date = Date.current)
    this_year = reactivation_on(date.year)
    this_year && this_year <= date ? this_year : reactivation_on(date.year - 1)
  end

  def next_due_on(from = Date.current)
    [due_on(from.year), due_on(from.year + 1)].compact.find { |date| date >= from }
  end

  def due_on_for_reminder(date, days_before)
    [due_on(date.year), due_on(date.year + 1)].compact.find { |due_date| due_date - days_before == date }
  end

  def due_date_label
    I18n.l(due_on(Date.current.year), format: "%d.%m.")
  end

  def reactivation_date_label
    I18n.l(reactivation_on(Date.current.year), format: "%d.%m.")
  end

  def complete!
    update!(completed: true, completed_at: Time.current)
  end

  def reactivate!(date: Date.current, update_reactivation_date: false)
    transaction do
      update!(
        completed: false,
        completed_at: nil,
        comment: "",
        last_reactivated_on: date,
        reactivation_month: update_reactivation_date ? date.month : reactivation_month,
        reactivation_day: update_reactivation_date ? date.day : reactivation_day
      )
      checklist_items.update_all(completed: false, completed_at: nil, updated_at: Time.current)
    end
  end

  private

  def dates_are_valid_calendar_days
    [[due_month, due_day, :due_day], [reactivation_month, reactivation_day, :reactivation_day]].each do |month, day, attribute|
      Date.new(2023, month, day)
    rescue Date::Error
      errors.add(attribute, "passt nicht zum ausgewählten Monat")
    end
  end

  before_validation :set_initial_reactivation_date, on: :create

  def set_initial_reactivation_date
    self.last_reactivated_on ||= current_cycle_reactivation_on
  end

  def responsible_user_is_management
    return if responsible_user.blank? || responsible_user.management?

    errors.add(:responsible_user, "muss eine Leitungsperson oder ein Admin sein")
  end
end
