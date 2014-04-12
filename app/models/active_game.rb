class ActiveGame < ActiveRecord::Base

  #TODO: Put a time limit on these rows. Find a gem to do that

  #has_many :game_events
  has_one :active_hand

  validates_presence_of :player_id

  def hand_complete
    write_attribute(:num_hands, read_attribute(:num_hands) + 1)
  end

end
