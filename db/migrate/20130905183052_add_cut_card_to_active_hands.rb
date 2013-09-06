class AddCutCardToActiveHands < ActiveRecord::Migration
  def change
    add_column :active_hands, :cut_card, :string
  end
end
