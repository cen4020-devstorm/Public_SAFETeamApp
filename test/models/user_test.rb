# test/models/user_test.rb
require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user should be valid with valid attributes" do
    user = users(:test_user)
    assert user.valid?
  end
end
