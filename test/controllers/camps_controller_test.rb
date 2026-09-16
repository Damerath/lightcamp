require "test_helper"

class CampsControllerTest < ActionDispatch::IntegrationTest
  test "signed-in user can view assigned camps" do
    sign_in_as

    get camps_path
    assert_response :success
  end

  test "regular user cannot create camps" do
    sign_in_as

    post camps_path, params: { camp: { name: "Testcamp" } }

    assert_redirected_to root_path
  end
end
