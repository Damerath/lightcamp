require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "admin can view the user administration" do
    sign_in_as("admin")

    get admin_path
    assert_response :success
  end
end
