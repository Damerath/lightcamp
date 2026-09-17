require "test_helper"

class LeadershipAnnualTasks::ReminderRunnerTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  setup { ActionMailer::Base.deliveries.clear }

  test "sends one direct email and one in-app notification for a due reminder" do
    responsible_user = management_user
    task = annual_task(responsible_user: responsible_user, due_month: 10, due_day: 15)
    task.reminders.create!(days_before: 7)

    travel_to Time.zone.local(2026, 10, 8, 9, 0, 0) do
      LeadershipAnnualTasks::ReminderRunner.run!(date: Date.current)
      LeadershipAnnualTasks::ReminderRunner.run!(date: Date.current)
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_includes ActionMailer::Base.deliveries.last.subject, task.title
    assert_equal 1, responsible_user.notification_deliveries.channel_kind_in_app.count
    assert_equal 1, task.reminder_deliveries.count
    assert task.reminder_deliveries.first.emailed_at.present?
  end

  test "resets a completed task, its comment and checklist at the reactivation date" do
    task = annual_task(reactivation_month: 8, reactivation_day: 1, completed: true, completed_at: Time.current, comment: "Bestellung ist raus")
    item = task.checklist_items.create!(text: "Bestellen", position: 0, completed: true, completed_at: Time.current)
    task.update_column(:last_reactivated_on, Date.new(2025, 8, 1))

    LeadershipAnnualTasks::ReminderRunner.run!(date: Date.new(2026, 8, 1))

    assert_not task.reload.completed?
    assert_equal "", task.comment
    assert_equal Date.new(2026, 8, 1), task.last_reactivated_on
    assert_not item.reload.completed?
  end

  private

  def management_user
    User.create!(email: "leitung-#{SecureRandom.uuid}@example.com", password: "test-password", role: "leader", first_name: "Lea")
  end

  def annual_task(responsible_user: management_user, **attributes)
    LeadershipAnnualTask.create!({
      title: "Mitarbeiteranmeldung",
      responsible_user: responsible_user,
      due_month: 10,
      due_day: 15,
      reactivation_month: 8,
      reactivation_day: 1,
      active: true
    }.merge(attributes))
  end
end
