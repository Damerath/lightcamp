require "test_helper"

class AdminBugReportsControllerTest < ActionDispatch::IntegrationTest
  test "regular users cannot view bug reports" do
    sign_in_as

    get admin_bug_reports_path

    assert_redirected_to root_path
  end

  test "admins can view bug reports" do
    sign_in_as("admin")

    get admin_bug_reports_path

    assert_response :success
  end

  test "admins can delete bug reports" do
    admin = sign_in_as("admin")
    report = BugReport.create!(user: admin, title: "Falsche Meldung", description: "Bitte entfernen.")

    assert_difference("BugReport.count", -1) do
      delete admin_bug_report_path(report)
    end

    assert_redirected_to admin_bug_reports_path
  end

  test "resolving a bug report notifies its reporter" do
    admin = sign_in_as("admin")
    reporter = User.create!(email: "reporter@example.com", password: "test-password")
    report = BugReport.create!(user: reporter, title: "Speichern funktioniert nicht", description: "Beim Speichern passiert nichts.")

    assert_difference("reporter.notification_deliveries.count", 2) do
      patch admin_bug_report_path(report), params: { bug_report: { status: "resolved", admin_notes: "Korrigiert." } }
    end

    assert report.reload.status_resolved?
    assert_equal "Bugreport gelöst", reporter.notification_deliveries.channel_kind_in_app.last.title
    assert_equal "Bugreport gelöst", reporter.notification_deliveries.channel_kind_email.last.title
  end
end
