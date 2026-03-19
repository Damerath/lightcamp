require "test_helper"

class CampsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get camps_index_url
    assert_response :success
  end
end
