require "test_helper"

class AdminCampsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_camps_index_url
    assert_response :success
  end
end
