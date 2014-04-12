class CribPlayer < ActiveRecord::Base
  has_secure_password validations:true
  validates_presence_of :username
  validates_presence_of :email
  validates_uniqueness_of :username

  has_one :player_stat
  has_many :game_stats

  #has_many games/stats
  #has_one active_game

  def update_stats(active_game)

    player_stat.update_stats(active_game)

  end

end
