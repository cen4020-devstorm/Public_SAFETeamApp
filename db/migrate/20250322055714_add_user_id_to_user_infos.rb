class AddUserIdToUserInfos < ActiveRecord::Migration[8.0]
  def change
    add_reference :user_infos, :user, foreign_key: true
  end
end