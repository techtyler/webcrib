class PeggingController < ScoreController

  #TODO: Automatically peg the users last card for them

  after_filter :flash_to_headers # currently redundant since only thing u can do is peg, only: 'peg'

	def peg

    #locate ActiveHand model if it exists
    return unless retrieve_active_hand?

    unless  valid_peg_choice?   #this is false when the peg choice is invalid (picked a king at sum = 25 for example)
      #This doesn't show until a full refresh of the page. Since pegging is done through AJAX we need to update these messages
        #using javascript somehow
      new_game_message('Invalid peg choice. Please choose a card such that the new sum is less than 32')

      return
    end
    begin

      process_peg_choice

    rescue GameOverException
    end

  end


  private

  def valid_peg_choice?

    #make sure form is valid
    @peg_index = params[:pegs].first.to_i

    return false unless @peg_index

    #initialize temporary/view variables
    @sum = @hand.peg_sum
    @peg_stack = @hand.current_peg_stack
    @player_peg, @ai_peg = @hand.peg_hands
    @peg_card = @player_peg[@peg_index]

    #make sure card choice is valid
    return @peg_card && !(@sum + @peg_card.value > 31) #TODO: Only show Radio Buttons for valid moves?


  end

  def process_peg_choice

    process_player_play 
    determine_player_peg_states #defines and sets @(player/ai)_can_play(round)
    check_if_player_ended_round

    process_ai_round

    #check_if_ai_ended_round
      #refresh ai_can_play, ai_can_play_round
      #if ai_can_play || user_can_play && (!ai_can_play_round && !user_can_play_round)
        #end peg round

    if @player_can_play_round
      return
    elsif !@ai_can_play_round

    end



    if !@player_can_play && @ai_can_play
      #AI has already played this round, and since the user cant play anymore, the AI needs to play the rest of his cards
      play_rest_of_ai_hand
    elsif !@player_can_play && !@ai_can_play
      end_pegging
    end

  end

  def check_if_player_ended_round

    if @sum == 31 || (!@ai_can_play_round && !@player_can_play_round)

      @ai_can_play_round = @ai_peg.any?
      @player_can_play_round = @player_peg.any?

      if @ai_can_play_round || @player_can_play_round
        end_peg_round  #don't call end_peg_round since end_pegging will soon be called
      end


    end

  end

  def determine_player_peg_states

    @player_can_play, @player_can_play_round = can_play(@sum, @player_peg)
    @ai_can_play, @ai_can_play_round = can_play(@sum, @ai_peg)

  end

  #Will play as once unless player gives a go, then it will play until the end of the round
  def process_ai_round

    @ai_played = 0
    while @ai_can_play_round
      @ai_played += 1
      process_ai_play
      @ai_can_play = @ai_peg.any?
      @player_can_play_round = can_play_round?(@sum, @player_peg) if @player_can_play_round
      if @player_can_play_round || !@ai_can_play
        @ai_can_play_round = false  #Ai can only play once if the player can still play
      else
        @ai_can_play_round = can_play_round?(@sum, @ai_peg)   #Check to see if Ai can continue to go, if so, keep processing his plays

      end
    end

    #if the AI played and ended a round, then let him score a point and reset the model!
    if (@ai_played > 0 && !@player_can_play_round) && (@ai_can_play || @player_can_play)
      end_peg_round
    end

  end

  def process_peg_move(peg_card)

    #update stack and sum
    @sum += peg_card.value
    @peg_stack << peg_card

    @hand.card_pegged!(peg_card)
    peg_score = 0
    if @peg_stack.size > 1
      peg_score = Crib::Util::PeggingCountingMethods.score_stack(@peg_stack.dup, @sum)
    end

    return peg_score

  end

  def end_peg_round

    if @sum != 31 && @sum != 15
      if @ai_played && @ai_played > 0
        score_ai_points(1, 'from a go.')   #dont score this point if it is the last card pegged.
      else
        score_user_points(1, 'from a go.')
      end
    end

    @sum = 0
    @peg_stack = []
    @hand.peg_round_complete

  end

  def end_pegging

    if (@sum != 31 && @sum != 15)
      if (@ai_played > 0)
        score_ai_points(1, 'from playing the last card.')
      else
        score_user_points(1, 'from playing the last card')
      end
    end
    cut = @hand.cut_card_decoded
    @player_hand_score = Crib::Util::HandCountingMethods.score_hand(@hand.player_hand + [cut], false)[0]
    @ai_hand_score = Crib::Util::HandCountingMethods.score_hand(@hand.ai_hand + [cut], false)[0]
    @player_crib_score = 0
    @ai_crib_score = 0

    if @hand.dealer?
      @player_crib_score = Crib::Util::HandCountingMethods.score_hand(@hand.crib + [cut], true)[0]
    else
      @ai_crib_score = Crib::Util::HandCountingMethods.score_hand(@hand.crib + [cut], true)[0]
    end

    if (@hand.dealer?)

      score_ai_points(@ai_hand_score, 'counting hand.')

      score_user_points(@player_hand_score + @player_crib_score,  'counting hand and crib.')

    else

      score_user_points(@player_hand_score,  'counting hand.')

      score_ai_points(@ai_hand_score + @ai_crib_score, 'counting hand and crib.')


    end

  end

  def can_play(sum, hand)

    playable = hand.any?
    round = (playable && can_play_round?(sum, hand))

    return playable, round

  end

  #This currently assumes that hands are sorted by value (lowest to highest)
  def can_play_round?(sum, hand)
    return hand.first.value + sum < 32
  end


  def play_rest_of_ai_hand

    #TODO: Validate this breaks when an ai play wins the game

    while @ai_peg.any?
      @ai_can_play_round = can_play_round?(@sum, @ai_peg)
      unless @ai_can_play_round
        end_peg_round
      end
      process_ai_play
    end
    end_pegging

  end

  #TODO: How to play and improved readme


  def process_play(card, hand)

    score = process_peg_move(card)
    hand.delete(card)
    return score
  end



  def process_player_play
    play_score =  process_play(@peg_card, @player_peg)
    score_user_points(play_score, 'pegging the ' + @peg_card.to_s)
  end

  def process_ai_play


    #ask gordon for play (should be guaranteed )
    ai_peg_card = Crib::Util::CribAIGordon.peg_card(@ai_peg, @peg_stack, @sum)
    play_score =  process_play(ai_peg_card, @ai_peg)
    score_ai_points(play_score, 'pegging the ' + ai_peg_card.to_s)

  end

end
