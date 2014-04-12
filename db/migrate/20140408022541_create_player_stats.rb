class CreatePlayerStats < ActiveRecord::Migration
  def change
    create_table :player_stats do |t|
      t.integer :crib_player_id
      t.integer :games_played
      t.integer :games_won
      t.integer :skunks
      t.string :best_hand
      t.string :best_peg
      t.integer :lowest_ai_score

      t.timestamps
    end
  end
end
