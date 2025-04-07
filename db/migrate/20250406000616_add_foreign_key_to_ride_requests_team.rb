class AddForeignKeyToRideRequestsTeam < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :ride_requests, :teams
  end
end
