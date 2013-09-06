class CreateActiveGames < ActiveRecord::Migration
  def change
    create_table :active_games do |t|
      t.integer :player_id
      t.integer :p1_score
      t.integer :p2_score
      t.integer :num_hands
      t.string :workflow_state

      t.timestamps
    end
  end
end
