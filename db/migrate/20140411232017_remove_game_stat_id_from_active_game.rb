class RemoveGameStatIdFromActiveGame < ActiveRecord::Migration
  def change
    remove_column :active_games, :game_stat_id, :integer
  end
end
