require "test_helper"

class YearsControllerTest < ActionDispatch::IntegrationTest
  test "leader can view years" do
    sign_in_as("leader")

    get years_path
    assert_response :success
  end

  test "regular user cannot view years" do
    sign_in_as

    get years_path

    assert_redirected_to root_path
  end
end
