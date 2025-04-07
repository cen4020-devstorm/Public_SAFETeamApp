require "application_system_test_case"

class DatabaseIntegrityTest < ApplicationSystemTestCase
  test "uses MariaDB/MySQL2 adapter" do
    adapter = ActiveRecord::Base.connection.adapter_name.downcase
    assert_equal "mysql2", adapter, "Expected adapter to be mysql2, but got #{adapter.inspect}"
  end

  test "testUser and AnotherUser are present in the database" do
    usernames = User.pluck(:username)
    assert_includes usernames, "testuser", "Expected seed user 'testUser' to exist"
    assert_includes usernames, "anotherUser", "Expected seed user 'Bob' to exist"
  end
end
