require "test_helper"

class BugReportsControllerTest < ActionDispatch::IntegrationTest
  test "signed-in users can submit a bug report" do
    admin = User.create!(email: "admin@example.com", password: "test-password", role: "admin", first_name: "Admin")
    sign_in_as

    assert_emails 1 do
      assert_difference("BugReport.count", 1) do
        post bug_reports_path, params: {
          bug_report: {
            category: "functionality",
            title: "Speichern funktioniert nicht",
            description: "Beim Speichern bleibt die Seite unverändert.",
            page_url: "https://example.test/camps",
            browser_details: "Test browser",
            viewport: "1280 x 800"
          }
        }
      end
    end

    assert_redirected_to root_path
    assert_equal "Speichern funktioniert nicht", BugReport.last.title
    assert_equal [admin.email], ActionMailer::Base.deliveries.last.to
  end
end
