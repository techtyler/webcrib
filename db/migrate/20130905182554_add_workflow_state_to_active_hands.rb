class AddWorkflowStateToActiveHands < ActiveRecord::Migration
  def change
    add_column :active_hands, :workflow_state, :string
  end
end
