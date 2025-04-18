require "test_helper"

class RideRequestsQueueTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:test_user)

    post login_path, params: {
      username: @user.username,
      password: "Password123!" 
    }
  end

  test "should assign the team with earliest availability" do
    Team.delete_all 
    team1 = Team.create!(name: "Alpha", available_at: 10.minutes.from_now)
    team2 = Team.create!(name: "Bravo", available_at: 5.minutes.from_now)

    post ride_requests_path, params: {
      ride_request: {
        name: "Test",
        phone: "123",
        location: "15210 Amberly Dr.",
        destination: "4202 E Fowler Ave"
      }
    }

    request = RideRequest.last

    assert_equal team2.id, request.team_id, "Should assign team with earliest available time"
  end

  test "should assign immediately available team" do
    Team.delete_all 
    team = Team.create!(name: "Immediate", available_at: nil) # or use Time.current
  
    post ride_requests_path, params: {
      ride_request: {
        name: "Test",
        phone: "123",
        location: "15210 Amberly Dr.",
        destination: "4202 E Fowler Ave"
      }
    }
  
    request = RideRequest.last
    assert_equal team.id, request.team_id, "Should assign the available-now team"
  end

  test "should update team's available_at after assignment" do
    Team.delete_all 
    team = Team.create!(name: "UpdateTeam", available_at: Time.current)
  
    post ride_requests_path, params: {
      ride_request: {
        name: "Test",
        phone: "123",
        location: "15210 Amberly Dr.",
        destination: "4202 E Fowler Ave"
      }
    }
  
    team.reload
    request = RideRequest.last
  
    assert_equal request.team_id, team.id
    assert team.available_at > Time.current, "Team should have updated availability after assignment"
  end
  
end
