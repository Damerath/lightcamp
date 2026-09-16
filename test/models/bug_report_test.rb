require "test_helper"

class BugReportTest < ActiveSupport::TestCase
  test "requires a title and description" do
    report = BugReport.new(user: User.create!(email: "reporter@example.com", password: "test-password"))

    assert_not report.valid?
    assert_includes report.errors[:title], "darf nicht leer sein"
    assert_includes report.errors[:description], "darf nicht leer sein"
  end

  test "starts as a new report" do
    report = BugReport.create!(user: User.create!(email: "new-reporter@example.com", password: "test-password"), title: "Speichern geht nicht", description: "Beim Speichern passiert nichts.")

    assert report.status_reported?
    assert report.category_functionality?
  end
end
