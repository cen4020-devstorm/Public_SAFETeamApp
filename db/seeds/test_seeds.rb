if Rails.env.test?
  puts "Seeding test data..."

  User.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!('users')

  User.create!(
    id: 1,
    username: "testUser",
    password: "Password123!",
    password_confirmation: "Password123!"
  )

  User.create!(
    id: 2,
    username: "anotherUser",
    password: "Password456!",
    password_confirmation: "Password456!"
  )

  RideRequest.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!('ride_requests')

  RideRequest.create!(
    name: "Test User",
    phone: "1234567890",
    location: "Library",
    destination: "Dorm",
    user_id: 1
  )

  RideRequest.create!(
    name: "Another User",
    phone: "9876543210",
    location: "Gym",
    destination: "Cafeteria",
    user_id: 2
  )
end