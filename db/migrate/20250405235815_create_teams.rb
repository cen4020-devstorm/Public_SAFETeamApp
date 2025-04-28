class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    unless table_exists?(:teams)
      create_table :teams do |t|
        t.string :name
        # other columns
        t.timestamps
      end
    end
  end
end
