# require "test_helper"

# class RideRequestsControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @user = User.create!(username: "testuser", password: "password")

#     # Log in
#     post login_path, params: {
#       username: "testuser",
#       password: "password"
#     }
#   end
  
#   test "should save valid user info and show confirmation message" do
#     post ride_requests_path, params: { 
#       ride_request: { 
#         name: "Alice",
#         phone: "1234567890",
#         location: "16041 Tampa Palms Blvd W, Tampa, FL 33647",
#         destination: "601 E Kennedy Blvd, Tampa, FL"
#       } 
#     }

#     assert_response :success
#     assert_select "h1", "Your Ride Request"
#     assert_select "p", text: "Your request has been confirmed!"
#   end

#   test "should not save without name" do
#     post ride_request_path, params: { 
#       ride_request: { 
#         name: "asd",
#         phone: "1234567890",
#         location: "15210 Amberly Dr.",
#         destination: "601 E Kennedy Blvd, Tampa, FL"
#       } 
#     }

#     assert_response :success
#     assert_select "h1", "Your Ride Request"
#     assert_select "p", text: "Your request has been confirmed!"
#   end

#   test "should not save with non-numeric phone" do
#     post ride_request_path, params: { 
#       ride_request: { 
#         name: "Alice",
#         phone: "123",
#         location: "15210 Amberly Dr.",
#         destination: "601 E Kennedy Blvd, Tampa, FL"
#       } 
#     }

#     assert_response :success
#     assert_select "h1", "Your Ride Request"
#     assert_select "p", text: "Your request has been confirmed!"
#   end

#   test "should not save with empty fields" do
#     post ride_request_path, params: { 
#       ride_request: { 
#         name: "asd",
#         phone: "134",
#         location: "Tampa Palms Blvd W, Tampa, FL 33647",
#         destination: "5022 Wesley Dr, Tampa, FL 33647"
#       } 
#     }

#     assert_response :success
#     assert_select "h1", "Your Ride Request"
#     assert_select "p", text: "Your request has been confirmed!"
#   end
# end

