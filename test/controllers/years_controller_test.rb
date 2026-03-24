require "test_helper"

class YearsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get years_index_url
    assert_response :success
  end
end
