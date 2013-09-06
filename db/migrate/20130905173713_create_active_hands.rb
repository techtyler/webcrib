class CreateActiveHands < ActiveRecord::Migration
  def change
    create_table :active_hands do |t|
      t.integer :player_id
      t.string :p1_hand
      t.string :p2_hand
      t.boolean :dealer
      t.string :crib_hand
      t.string :peg_stack
      t.integer :peg_sum
      t.integer :active_game_id

      t.timestamps
    end
  end
end
