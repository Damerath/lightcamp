require "test_helper"

class CampApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "signed-in user can open the application form" do
    sign_in_as
    Year.create!(name: "2026", registration_open: true, training_on: Date.new(2026, 5, 1))

    get camp_application_path
    assert_response :success
  end
end
