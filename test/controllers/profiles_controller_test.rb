require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "signed-in user can edit the profile" do
    sign_in_as

    get profile_path
    assert_response :success
  end
end
