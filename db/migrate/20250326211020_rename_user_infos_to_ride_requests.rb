class RenameUserInfosToRideRequests < ActiveRecord::Migration[8.0]
  def change
    rename_table :user_infos, :ride_requests
  end
end
