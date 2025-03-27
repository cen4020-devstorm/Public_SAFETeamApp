class CreateUserInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :user_infos do |t|
      t.string :name
      t.string :phone
      t.string :location
      t.string :destination

      t.timestamps
    end
  end
end
