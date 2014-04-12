class ActiveHandsController < ScoreController

  after_filter :flash_to_headers, only: 'throw'


  #vars that can be taken out of instance (for heavy class warning)
  # @peg_stack, @ai_played, @peg_card, 4 peg_state vars ???? @sum, @peg_index, ...

  def hand
    return unless retrieve_active_hand?
    gon.watch.rabl template: 'app/views/active_hands/hand.rabl', as: 'hand'
  end

  def throw

    #locate ActiveHand model if it exists
    return unless retrieve_active_hand?

    #read player throw decision (false if form filled out incorrectly)
    unless read_throw_choice?
      #TODO Test that we don't need a redirect
      new_game_message('Invalid choice, please select two cards to pass to the crib.')
      render nothing: true
      return
    end
    begin
      process_throw_choice
    rescue GameOverException => e
      return
    end


  end


  private


  def read_throw_choice?

    #read form
    cards = params[:cards]
    if cards && cards.size == 2  #find somewhere else to perform this logic ( improve UI with JavaScript )
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

    return if @game_over #GAME OVER CALL

    if @hand.dealer #user is dealer, let ai peg
      ai_first_peg = Crib::Util::CribAIGordon.peg_card(@hand.ai_hand, [], 0)
      @hand.card_pegged!(ai_first_peg)
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
    @cut_card = Crib::Deck.new.cut_deck(player_hand + ai_hand) #TODO Change this to user cut?  (might have to save deck state for a bit)
    #(award points if jack)
    if @cut_card.number == 11
      if @hand.dealer?
        score_user_points(2, 'knobs.')
      else
        score_ai_points(2, 'knobs.')
      end
    end

  end



end
