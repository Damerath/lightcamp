class BugReportMailer < ApplicationMailer
  def new_report(admin:, bug_report:)
    @admin = admin
    @bug_report = bug_report

    mail(to: admin.email, subject: "Neuer Bugreport ##{bug_report.id}: #{bug_report.title}")
  end
end
