require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "leader can manage operations without admin privileges" do
    user = User.new(role: "leader")

    assert_predicate user, :leader?
    assert_predicate user, :management?
    assert_not_predicate user, :admin?
  end

  test "admin can manage operations" do
    user = User.new(role: "admin")

    assert_predicate user, :management?
  end
end
