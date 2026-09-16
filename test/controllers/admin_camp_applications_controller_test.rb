require "test_helper"

class AdminCampApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "leader can view applications" do
    sign_in_as("leader")

    get admin_camp_applications_path
    assert_response :success
  end
end
