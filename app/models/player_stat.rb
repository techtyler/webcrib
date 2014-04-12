class PlayerStat < ActiveRecord::Base
  belongs_to :crib_player


  def update_stats(active_game)

    self.games_played += 1
    if active_game.p1_score > 120
      self.games_won += 1

      if (active_game.p2_score < 91)
        self.skunks += 1
        if (active_game.p2_score < 61)
          self.skunks += 1
        end
      end

    end

    if self.lowest_ai_score > active_game.p2_score
      self.lowest_ai_score = active_game.p2_score
    end


    #TODO update :best_hand
    #TODO update t.string :best_peg (include stack??)

    save

  end


end
