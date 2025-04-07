class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.datetime :available_at

      t.timestamps
    end
  end
end
