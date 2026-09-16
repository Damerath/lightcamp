require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "admin can view users" do
    sign_in_as("admin")

    get users_path
    assert_response :success
  end
end
