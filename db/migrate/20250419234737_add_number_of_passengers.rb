class AddNumberOfPassengers < ActiveRecord::Migration[7.1]
  def change
    add_column :ride_requests, :number_of_passengers, :integer
  end
end