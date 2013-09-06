class ActiveHandsController < ApplicationController

  def throw

    #locate ActiveHand model if it exists
    return if not retrieve_active_hand?

    #read player throw decision (false if form filled out incorrectly)
    if not read_throw_choice?
      redirect_to play_path, notice: 'Invalid choice, please select two cards to pass to the crib.'
      return
    end

    cut_card_and_score

    if (@hand.dealer)

      #TODO Figure out how to start pegging correctly (will throw be able to include peg if it needs to?)
      #TODO What variables need to be accessed, with rendering 'peg' call the controller and do stuff (save state) there?

      #hand.first_peg!(ai_hand.first)
    end

  end

  def new #not called for first hand, only for recurring hands in the game

    #reset state of ActiveHand model (erase all fields and whatnot)
    #shuffle deck and deal

    return if not retrieve_active_hand?

    if @hand.workflow_state != 'hands_counted'
      redirect_to play_path, notice: 'You cannot start a new hand until the previous one is complete'
    end

    @hand.new_hand!
    @hand.deal!

  end


  private

  def read_throw_choice?
    #read form
    cards = params[:cards]
    if (cards && cards.size == 2)
      @p_throw1 = cards[0].to_i
      @p_throw2 = cards[1].to_i
    else
      return false
    end

    player_hand = @hand.player_hand
    ai_hand = @hand.ai_hand

    #get ai decision TODO: async call if it becomes a long algorithm?
    @ai_throw1, @ai_throw2 = Crib::Util::CribAIGordon.throw_to_crib(@hand.ai_hand, @hand.dealer)

    @crib_hand = [ player_hand[@p_throw1] ]
    @crib_hand << player_hand[@p_throw2]
    @crib_hand << ai_hand[@ai_throw1]
    @crib_hand << ai_hand[@ai_throw2]

    player_hand.delete_at(@p_throw1)
    player_hand.delete_at(@p_throw2 - 1)

    ai_hand.delete_at(@ai_throw1)
    ai_hand.delete_at(@ai_throw2 - 1)

    #update model with call to throw!
    @hand.throw!(player_hand, ai_hand, @crib_hand, @cut_card)

    return true

  end


  def retrieve_active_hand?
    hand_id = session[:hand_id]
    if !hand_id
      redirect_to play_path, notice: 'Invalid hand id!'
      return false
    end

    @hand = ActiveHand.find(hand_id)

    if !@hand
      redirect_to play_path, notice: "Could not locate the hand with id: #{hand_id}"
      return false
    end

    return true
  end

  def cut_card_and_score

    #cut deck (award points if jack, only load active_game if scoring is needed?)
    @cut_card = Crib::Deck.new.cut_deck(player_hand, ai_hand) #TODO Change this to user cut?  (might have to save deck state for a bit)
    if @cut_card.number == 11
      @game = @hand.active_game
      if @hand.dealer?
        @game.p1_score += 2
        if (@game.p1_score > 120)
          #Throw game over
          @game_over = true
        end
      else
        @game.p2_score += 2
        if (@game.p2_score > 120)
          @game_over = true
        end
      end
    end

  end
end
