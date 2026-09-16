require "test_helper"

class AdminCampsControllerTest < ActionDispatch::IntegrationTest
  test "leader can view camp administration" do
    sign_in_as("leader")

    get admin_camps_path
    assert_response :success
  end
end
