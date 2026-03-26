require "test_helper"

class CampApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get camp_applications_new_url
    assert_response :success
  end
end
