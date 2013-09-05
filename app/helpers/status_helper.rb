module StatusHelper

  def number_of_players
    CribPlayer.all.size.to_s
    #get size of players table
  end

  def number_of_games
    #get size of games table
    '234,567'
  end

  def number_of_sessions
    #get size of active games table
    #or subset of players that have been touched within the last 10min or something
    '654'
  end

  def number_of_wins
    '123,456'
    #get games length where win_id is contained in players
  end
end
