class ScoreController < ApplicationController




  #Idea. Make a class that does the meta of a move (throw, peg) that does the following:
        #Validates User
        #Retreives ActiveGame/Hand Models
        #





  #

  def score_ai_points(value, how)
    @hand.active_game.p2_score = score_points(value, @hand.active_game.p2_score, 'AI_Gordon', how)
    @hand.active_game.save
    if (@game_over)
      process_game_over
      flash[:game] << "You Lost. Play again?"
      raise GameOverException.new 'Ai Won!'
    end
  end

  def score_user_points(value, how)
    @hand.active_game.p1_score = score_points(value, @hand.active_game.p1_score, 'User', how)
    @hand.active_game.save
    if @game_over
      process_game_over
      flash[:game] << "You Win. Play again?"
      raise GameOverException.new 'User Won!'
    end
  end

  private

  def score_points(value, total, who, how)

    #have how be an id to a hash of different ways to score
    #each id would provide a format for where to plug in value and who.

    total += value

    if (value > 0)
      new_game_message( who + ' scored ' + value.to_s + ' points by ' + how )
    end

    if (total > 120)
      @game_over = true
      return 121
    end

    return total

  end



  def process_game_over
    #set flag

    #save scores first?

    #update stats
    current_player.update_stats(@hand.active_game)

    game_stat = GameStat.new(:crib_player_id => session[:player_id],
                             :user_score => @hand.active_game.p1_score,
                             :ai_score => @hand.active_game.p2_score,
                             :hands_played => @hand.active_game.num_hands,
                              :ai_id => 1)
    game_stat.save
    #@hand.delete We need to clean this up when the next hand is created. The UI still needs to
    session[:game_id] = nil
    @hand.active_game.delete
  end

end

