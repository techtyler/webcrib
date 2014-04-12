class RemoveWorkflowStateFromActiveGames < ActiveRecord::Migration
  def change
    remove_column :active_games, :workflow_state
  end
end
