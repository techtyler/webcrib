class AddColumnGameStatIdToActiveGames < ActiveRecord::Migration
  def change
    add_column :active_games, :game_stat_id, :integer
  end
end
