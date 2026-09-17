module LeadershipAnnualTasks
  class ReminderRunner
    class << self
      def run!(date: Time.find_zone!("Europe/Berlin").today)
        reactivate_due_tasks!(date: date)
        send_due_reminders!(date: date)
      end

      private

      def reactivate_due_tasks!(date:)
        LeadershipAnnualTask.active.find_each do |task|
          cycle_start = task.current_cycle_reactivation_on(date)
          next if cycle_start.blank? || task.last_reactivated_on == cycle_start

          task.reactivate!(date: cycle_start)
        end
      end

      def send_due_reminders!(date:)
        LeadershipAnnualTask.active.open.includes(:responsible_user, :reminders).find_each do |task|
          task.reminders.each do |reminder|
            due_on = task.due_on_for_reminder(date, reminder.days_before)
            next if due_on.blank?

            delivery = task.reminder_deliveries.find_or_create_by!(leadership_annual_task_reminder: reminder, due_on: due_on)
            send_in_app_notification!(task, due_on, delivery)
            send_email!(task, due_on, delivery)
          rescue StandardError => error
            Rails.logger.error("Annual task reminder for task #{task.id} failed: #{error.class}: #{error.message}")
          end
        end
      end

      def send_in_app_notification!(task, due_on, delivery)
        return if delivery.in_app_notified_at.present?

        Notifications::Publisher.publish!(
          key: "leadership_annual_task_reminder",
          metadata: { leadership_annual_task_id: task.id, due_on: due_on.iso8601 },
          deliveries: [{
            user: task.responsible_user,
            title: "Erinnerung: #{task.title}",
            body: "Stichtag für diese Jahresaufgabe ist am #{I18n.l(due_on, format: '%d.%m.%Y')}.",
            link_url: Rails.application.routes.url_helpers.leadership_annual_task_path(task),
            channel_kinds: [:in_app]
          }]
        )
        delivery.update!(in_app_notified_at: Time.current)
      end

      def send_email!(task, due_on, delivery)
        return if delivery.emailed_at.present?

        LeadershipAnnualTaskReminderMailer.reminder(task: task, due_on: due_on).deliver_now
        delivery.update!(emailed_at: Time.current)
      end
    end
  end
end
