require "test_helper"

class RideRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(username: "testuser", password: "password")

    # Log in
    post login_path, params: {
      username: "testuser",
      password: "password"
    }
  end
  
end

