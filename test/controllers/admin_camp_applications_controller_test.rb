require "test_helper"

class AdminCampApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_camp_applications_index_url
    assert_response :success
  end
end
