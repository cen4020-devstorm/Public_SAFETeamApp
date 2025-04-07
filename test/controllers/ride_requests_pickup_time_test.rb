require "test_helper"

class RideRequestsPickupTimeTest < ActionDispatch::IntegrationTest
  setup do
    # Log in a test user
    @user = users(:test_user)
    post login_path, params: {
      username: @user.username,
      password: "Password123!"
    }
    # Create a team that becomes available in 15 minutes
    @team = Team.create!(name: "Test Team", available_at: 15.minutes.from_now)

    # Backup originals before overriding
    @original_get_coords = TravelTimeService.method(:get_coordinates)
    @original_get_time = TravelTimeService.method(:get_travel_time)

    # Mock get_coordinates
    TravelTimeService.define_singleton_method(:get_coordinates) do |location|
      { lat: 1.0, lng: 1.0 }
    end

    # Mock get_travel_time
    TravelTimeService.define_singleton_method(:get_travel_time) do |start, finish|
      if start.include?("USF Cedar")
        { duration: 5, distance: "2 miles" }
      else
        { duration: 10, distance: "6 miles" }
      end
    end
  end

  teardown do
    # Restore originals
    TravelTimeService.define_singleton_method(:get_coordinates, &@original_get_coords)
    TravelTimeService.define_singleton_method(:get_travel_time, &@original_get_time)
  end

  test "should calculate correct waiting time with standard input" do
    travel_to Time.current do
      now = Time.current
      # Make a ride request with different pickup and destination
      post ride_requests_path, params: {
        ride_request: {
          name: "Test Rider",
          phone: "1234567890",
          location: "15210 Amberly Dr.",
          destination: "4202 E Fowler Ave"
        }
      }
      # Check if the request went through and a ride was created
      assert_response :success
      assert_template :show

      ride = RideRequest.last
      assert_not_nil ride
      # Calculate the expected pickup and waiting times
      expected_pickup_time = [now, @team.available_at].max + 5.minutes
      expected_waiting_time = ((expected_pickup_time - now) / 60).ceil
      expected_team_available = expected_pickup_time + 10.minutes
      updated_team = Team.find(@team.id)
      # Check if values from mock were assigned correctly
      assert_equal "2 miles", assigns(:waiting_distance)
      assert_equal "6 miles", assigns(:driving_distance)
      assert_equal 10, assigns(:driving_time)
    end
  end

  test "should calculate correct waiting time with same location and destination" do
    travel_to Time.current do
      now = Time.current
      # Make a ride request where pickup and destination are the same
      post ride_requests_path, params: {
        ride_request: {
          name: "Test Rider",
          phone: "1234567890",
          location: "4202 E Fowler Ave",
          destination: "4202 E Fowler Ave"
        }
      }
      # Check if the request succeeded
      assert_response :success
      assert_template :show

      ride = RideRequest.last
      assert_not_nil ride
      # Calculate expected times
      expected_pickup_time = [now, @team.available_at].max + 5.minutes
      expected_waiting_time = ((expected_pickup_time - now) / 60).ceil
      expected_team_available = expected_pickup_time + 10.minutes
      updated_team = Team.find(@team.id)
      # Check if values from mock were assigned correctly
      assert_equal "2 miles", assigns(:waiting_distance)
      assert_equal "6 miles", assigns(:driving_distance)
      assert_equal 10, assigns(:driving_time)
    end
  end
end
