require "test_helper"

class RideRequestTest < ActiveSupport::TestCase
  def setup
    @user = users(:one) # Assuming you have a fixture for users
    @team = teams(:one) # Assuming you have a fixture for teams
    @ride_request = RideRequest.new(
      name: "John Doe",
      phone: "1234567890",
      location: "123 Main St",
      destination: "456 Elm St",
      number_of_passengers: 1,
      user: @user,
      team: @team
    )
  end

  test "should be valid with valid number_of_passengers" do
    assert @ride_request.valid?
  end

  test "should not be valid with number_of_passengers less than 1" do
    @ride_request.number_of_passengers = 0
    assert_not @ride_request.valid?
    assert_includes @ride_request.errors[:number_of_passengers], "You must have at least 1 passenger."
  end

  test "should not be valid with number_of_passengers greater than 2" do
    @ride_request.number_of_passengers = 3
    assert_not @ride_request.valid?
    assert_includes @ride_request.errors[:number_of_passengers], "Online requests are limited to 2 passengers. Please call 813-974-SAFE (7233) for larger groups."
  end

  test "should be valid with number_of_passengers equal to 2" do
    @ride_request.number_of_passengers = 2
    assert @ride_request.valid?
  end

  test "should not be valid without number_of_passengers" do
    @ride_request.number_of_passengers = nil
    assert_not @ride_request.valid?
    assert_includes @ride_request.errors[:number_of_passengers], "The number of passengers must be a number"
  end
end