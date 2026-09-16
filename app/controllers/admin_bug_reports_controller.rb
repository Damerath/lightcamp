class AdminBugReportsController < ApplicationController
  before_action :require_admin
  before_action :set_bug_report, only: %i[show update destroy]

  def index
    @selected_status = params[:status].presence_in(BugReport.statuses.keys)
    @bug_reports = BugReport.includes(:user, screenshot_attachment: :blob).order(created_at: :desc)
    @bug_reports = @bug_reports.where(status: @selected_status) if @selected_status.present?
  end

  def show
  end

  def update
    previously_resolved = @bug_report.status_resolved?

    if @bug_report.update(admin_bug_report_params)
      BugReports::Notifier.report_resolved!(@bug_report, actor: current_user) if !previously_resolved && @bug_report.status_resolved?
      redirect_to admin_bug_report_path(@bug_report), notice: "Bugreport wurde aktualisiert."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @bug_report.destroy
    redirect_to admin_bug_reports_path, notice: "Bugreport wurde gelöscht."
  end

  private

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end

  def set_bug_report
    @bug_report = BugReport.find(params[:id])
  end

  def admin_bug_report_params
    params.require(:bug_report).permit(:status, :admin_notes)
  end
end
