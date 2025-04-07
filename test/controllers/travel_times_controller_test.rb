require "test_helper"

class TravelTimeControllerTest < ActionDispatch::IntegrationTest
  

  test "should show error message for invalid pickup location" do
    post ride_requests_path, params: { 
      ride_request: { 
        number_of_passengers: 1,
        name: "Alice",
        phone: "1234567890",
        location: "Invalid Address 1234",
        destination: "601 E Kennedy Blvd, Tampa, FL"
      } 
    }

    assert_response :unprocessable_entity
    assert_select "p", /Invalid pickup location/
  end

  test "should display estimated waiting time for valid location" do
    post ride_requests_path, params: { 
      ride_request: { 
        number_of_passengers: 1,
        name: "Alice",
        phone: "1234567890",
        location: "15210 Amberly Dr.",
        destination: "601 E Kennedy Blvd, Tampa, FL"
      } 
    }
  
    assert_response :success
    assert_select "h1", "Your Ride Request" 
    assert_select "p", text: "Your request has been confirmed!"  
    assert_select "strong", text: "Time Until Pickup:"  
    assert_select "strong", text: "Driver Distance:"  
  end
end

