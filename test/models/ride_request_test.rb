
require "test_helper"

class UserInfoTest < ActiveSupport::TestCase
 
  test "should not save without name" do
    user_info = UserInfo.new(phone: "1234567890", location: "New York", destination: "Los Angeles")
    assert_not user_info.save, "Saved the user info without a name"
  end

  test "should not save with non-numeric phone" do
    user_info = UserInfo.new(name: "Alice", phone: "abc123", location: "New York", destination: "Los Angeles")
    assert_not user_info.save, "Saved the user info with a non-numeric phone number"
  end

  test "should not save with empty fields" do
    user_info = UserInfo.new(name: "", phone: "", location: "", destination: "")
    assert_not user_info.save, "Saved the user info with empty fields"
  end
end

