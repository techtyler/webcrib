module StatusHelper

  def number_of_players
    CribPlayer.count
    #get size of players table
  end

  def number_of_games
    return GameStat.count
  end

  def number_of_sessions
    return ActiveHand.count
  end

  def number_of_wins
    current_player.player_stat.games_won
  end
end
