class ActiveGame < ActiveRecord::Base

  #has_many :game_events
  has_one :active_hand

  validates_presence_of :player_id

  include Workflow
  workflow do

    state :started do
      event :initialized, transition_to: :hand_start
    end

    state :hand_start do
      event :cards_dealt, transition_to: :hand_playing
    end

    state :hand_playing do
      event :hand_complete, transition_to: :hand_finished
    end
    state :hand_finished do
      event :next_hand, transition_to: :hand_start
    end

    #instead of having a final state, the model will be removed when the game is completed

  end


end
