class BugReportsController < ApplicationController
  def create
    report = current_user.bug_reports.new(bug_report_params)

    if report.save
      BugReports::Notifier.report_created!(report)
      redirect_back fallback_location: root_path, notice: "Danke! Dein Bugreport ##{report.id} wurde gesendet."
    else
      redirect_back fallback_location: root_path, alert: report.errors.full_messages.to_sentence
    end
  end

  private

  def bug_report_params
    params.require(:bug_report).permit(:category, :title, :description, :screenshot, :page_url, :browser_details, :viewport)
  end
end
