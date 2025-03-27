require "test_helper"

class TravelTimeServiceTest < ActiveSupport::TestCase
  test "should display estimated waiting time for a valid location" do
    valid_location = "15210 Amberly Dr."
    driver_location = "4103 USF Cedar Cir, Tampa, FL 33620"
    result = TravelTimeService.get_travel_time(driver_location, valid_location)
    assert_not_nil result[:duration], "Expected a duration, but got nil"
    assert_not_nil result[:distance], "Expected a distance, but got nil"
    assert_match /\d+ min/, result[:duration], "Duration format is incorrect"
    assert_match /\d+(\.\d+)? km/, result[:distance], "Distance format is incorrect"
  end
  test "should return error for invalid pickup location" do
    invalid_location = "Fake Address 1234"
    driver_location = "4103 USF Cedar Cir, Tampa, FL 33620"

    result = TravelTimeService.get_travel_time(driver_location, invalid_location)

    assert_not_nil result[:error], "Expected an error message for invalid location"
    assert_match /Failed to get coordinates/, result[:error], "Error message format is incorrect"
  end
  test "should return error for empty pickup location" do
    empty_location = ""
    driver_location = "4103 USF Cedar Cir, Tampa, FL 33620"

    result = TravelTimeService.get_travel_time(driver_location, empty_location)

    assert_not_nil result[:error], "Expected an error for empty address"
    assert_match /Invalid address/, result[:error], "Expected 'Invalid address' error"
  end
  test "should return error for nil pickup location" do
    nil_location = nil
    driver_location = "4103 USF Cedar Cir, Tampa, FL 33620"

    result = TravelTimeService.get_travel_time(driver_location, nil_location)

    assert_not_nil result[:error], "Expected an error for nil address"
    assert_match /Invalid address/, result[:error], "Expected 'Invalid address' error"
  end
end