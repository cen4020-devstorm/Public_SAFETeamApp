class AddNumberOfPassengersToRideRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :ride_requests, :number_of_passengers, :integer, default: 1, null: false
  end
end
