class LeadershipAnnualTaskReminderMailer < ApplicationMailer
  def reminder(task:, due_on:)
    @task = task
    @due_on = due_on
    @task_url = leadership_annual_task_url(task)

    mail(to: task.responsible_user.email, subject: "Erinnerung: #{task.title}")
  end
end
