require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "signed-in user can view the dashboard" do
    sign_in_as

    get root_path
    assert_response :success
  end
end
