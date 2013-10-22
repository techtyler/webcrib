class ActiveHandsController < ApplicationController

  #vars that can be taken out of instance (for heavy class warning)
  # @peg_stack, @ai_played, @peg_card, 4 can_play_(round) vars ???? @sum, @peg_index, ...

  def hand
    return if not retrieve_active_hand?
    gon.watch.rabl template: 'app/views/active_hands/hand.rabl', as: 'hand'
  end

  def throw

    #locate ActiveHand model if it exists
    return if not retrieve_active_hand?

    #read player throw decision (false if form filled out incorrectly)
    unless read_throw_choice?
      redirect_to play_path, notice: 'Invalid choice, please select two cards to pass to the crib.'
      return
    end

    process_throw_choice

  end

  def peg

    #locate ActiveHand model if it exists
    return if not retrieve_active_hand?

    return if not  read_peg_choice?

    process_peg_choice

  end

  private

  def read_peg_choice?

    #make sure form is valid
    @peg_index = params[:pegs].first.to_i

    return false unless @peg_index

    #initialize temporary/view variables
    @sum = @hand.peg_sum
    @peg_stack = @hand.current_peg_stack
    @player_peg, @ai_peg = @hand.peg_hands
    @peg_card = @player_peg[@peg_index]

    #make sure card choice is valid
    if @sum + @peg_card.value > 31 #TODO: Only show Radio Buttons for valid moves?
      return false#Please pick a card to peg such that the sum <= 31.",
    end

    return true

  end

  def process_peg_choice

    process_player_play
    determine_player_peg_states
    check_if_player_ended_round

    process_ai_round

    if @player_can_play_round
      return
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
      end_peg_round
      @ai_can_play_round = @ai_peg.any?
      @player_can_play_round = @player_peg.any?
    end

  end

  def determine_player_peg_states

    @player_can_play, @player_can_play_round = can_play(@sum, @player_peg)
    @ai_can_play,@ai_can_play_round = can_play(@sum, @ai_peg)

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
    if @ai_played > 0 && !@player_can_play_round
      end_peg_round
    end

  end

  def play_rest_of_ai_hand

    while @ai_peg.any?
      @ai_can_play_round = can_play_round?(@sum, @ai_peg)
      unless @ai_can_play_round
        end_peg_round
      end
      process_ai_play
    end

  end

  def process_player_play

    player_peg_score = process_peg_move(@peg_card)
    @player_peg.delete_at(@peg_index)
    @hand.active_game.add_player_points( player_peg_score )

  end

  def process_ai_play
    #ask gordon for play (should be guaranteed )
    ai_peg_card = Crib::Util::CribAIGordon.peg_card(@ai_peg, @peg_stack, @sum)
    if ai_peg_card == -1
      return false
    end

    ai_peg_score = process_peg_move(ai_peg_card)
    @ai_peg.delete(ai_peg_card)
    @hand.active_game.add_ai_points(ai_peg_score)

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
        unless @hand.active_game.add_ai_points(1)
          @game_over = true
        end
      else
        unless @hand.active_game.add_player_points(1)
          @game_over = true
        end
      end
    end

    @sum = 0
    @peg_stack = []
    @hand.peg_round_complete

  end

  def end_pegging

    @player_hand_score = Crib::Util::HandCountingMethods.score_hand(@hand.player_hand.dup << @hand.cut_card_decoded, false)[0]
    @ai_hand_score = Crib::Util::HandCountingMethods.score_hand(@hand.ai_hand.dup << @hand.cut_card_decoded, false)[0]
    @player_crib_score = 0
    @ai_crib_score = 0

    if @hand.dealer
      @player_crib_score = Crib::Util::HandCountingMethods.score_hand(@hand.crib.dup << @hand.cut_card_decoded, true)[0]
    else
      @ai_crib_score = Crib::Util::HandCountingMethods.score_hand(@hand.crib.dup << @hand.cut_card_decoded, true)[0]
    end

    if !@hand.active_game.add_player_points( @player_hand_score + @player_crib_score ) ||
        !@hand.active_game.add_ai_points( @ai_hand_score + @ai_crib_score )

      @game_over = true
      #TODO: Add in game over logic things (this should set a variable in @hand.json so that Throw(Cut) and Peg/Count can render appropriately)
    end

  end

  def can_play(sum, hand)

    playable = hand.any?
    round = (playable && can_play_round?(sum, hand))

    return playable, round

  end

  def can_play_round?(sum, hand)
    return hand.first.value + sum < 32
  end

  def read_throw_choice?

    #read form
    cards = params[:cards]
    if cards && cards.size == 2
      @p_throw1 = cards[0].to_i
      @p_throw2 = cards[1].to_i
    else
      return false
    end

    return true

  end

  def process_throw_choice

    @player_hand = @hand.player_hand
    @ai_hand = @hand.ai_hand

    #get ai decision TODO: async call if it becomes a long algorithm?
    ai_throw1, ai_throw2 = Crib::Util::CribAIGordon.throw_to_crib(@hand.ai_hand, @hand.dealer)

    combine_cards_to_crib(@p_throw1, @p_throw2, ai_throw1, ai_throw2)
    cut_card_and_score(@player_hand, @ai_hand)

    #update model with call to throw!
    @hand.throw!(@player_hand, @ai_hand, @crib_hand, @cut_card)

    if @hand.dealer #user is dealer, let ai peg
      @ai_first_peg = Crib::Util::CribAIGordon.peg_card(@hand.ai_hand, [], 0)
      @hand.card_pegged!(@ai_first_peg)
    end

  end

  def combine_cards_to_crib(user1, user2, ai1, ai2)

    @crib_hand = [ @player_hand.delete_at(user1) ]
    @crib_hand << @player_hand.delete_at(user2 - 1)
    @crib_hand << @ai_hand.delete_at(ai1)
    @crib_hand << @ai_hand.delete_at(ai2 - 1)

  end

  def cut_card_and_score(player_hand, ai_hand)
    #cut deck
    @cut_card = Crib::Deck.new.cut_deck(player_hand, ai_hand) #TODO Change this to user cut?  (might have to save deck state for a bit)
    #(award points if jack)
    if @cut_card.number == 11
      if @hand.dealer?
        unless @hand.active_game.add_player_points(2)
          @game_over = true
          #TODO: Add in game over logic things (this should set a variable in @hand.json so that Throw(Cut) and Peg/Count can render appropriately)
        end
      else
        unless @hand.active_game.add_ai_points(2)
          @game_over = true
          #TODO: Add in game over logic things (this should set a variable in @hand.json so that Throw(Cut) and Peg/Count can render appropriately)
        end
      end
    end

  end

  def retrieve_active_hand?

    hand_id = session[:hand_id]
    unless hand_id
      redirect_to play_path, notice: 'Invalid hand id!' # Should only be false if game somehow not created with a hand or loses it
      return false
    end

    @hand = ActiveHand.find(hand_id)

    unless @hand
      redirect_to play_path, notice: "Could not locate the hand with id: #{hand_id}"
      return false
    end

    return true

  end

end
