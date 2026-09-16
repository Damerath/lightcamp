require "test_helper"

class CampApplicationTest < ActiveSupport::TestCase
  test "recognizes anonymized applications" do
    application = CampApplication.new(anonymized_at: Time.current)

    assert application.anonymized?
  end

  test "recognizes active applications" do
    application = CampApplication.new

    assert_not application.anonymized?
  end
end
