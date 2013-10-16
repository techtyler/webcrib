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

  #def initialized
  #
  #end
  #
  #def cards_dealt
  #
  #end
  #
  #def hand_complete
  #  #TODO Load active_hand into Hand_Stats and save to DB
  #  #Read num_hands and increase it by 1
  #end
  #
  #def next_hand
  #
  #end

  def add_player_points(amount)
    add_points(:p1_score, amount)
  end

  def add_ai_points(amount)
    add_points(:p2_score, amount)
  end

  private

  def add_points(attribute, amount)
    prev = read_attribute(attribute)
    new = prev + amount
    write_attribute(attribute, new)
    save
    if new > 120
      return false
    else
      return true
    end

  end


  #TODO: Try to add a listener on @p1_score and @p2_score and when they change, throw a GameOverException when someone breaks 120
  # TODO: -- then the controller will catch the excpetion and render the GameOver prompt along with the last peg and counted hands (even if unnecessary aka win by peg)


end
