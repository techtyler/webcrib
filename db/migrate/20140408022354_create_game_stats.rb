class CreateGameStats < ActiveRecord::Migration
  def change
    create_table :game_stats do |t|
      t.integer :crib_player_id
      t.integer :ai_id
      t.integer :user_score
      t.integer :ai_score
      t.integer :hands_played

      t.timestamps
    end
  end
end
