class ActiveGamesController < ApplicationController

  include ActionController::Live #What is this again? (Looks to be required for the RABL? (allows data streams))

  #TODO: More comments

  def show
    return if redirect_guest?

    find_game

    if !@game
      check_for_old_hand
      create_game
    end

    @hand = @game.active_hand
    gon.watch.rabl template: 'app/views/active_hands/hand.rabl', as: 'hand'

  end

  def new_game
    return if redirect_guest?

    find_game
    if @game

      @game.active_hand.delete
      @game.delete
    else
      check_for_old_hand
    end

    redirect_to play_path
  end


  def new_hand
    return if redirect_guest?

    find_game
    if @game

      @game.active_hand.new_hand!
      @game.active_hand.deal!
      @game.num_hands += 1

      #if game is over, then start redirect to new_game?

    end

    redirect_to play_path
  end


  private


  def find_game
    @game = ActiveGame.find {|g| g.player_id == session[:player_id]}
  end

  def create_game
                                                                       #TODO: Change this back
    @game = ActiveGame.new(:player_id => session[:player_id], :p1_score => 60, :p2_score => 100, :num_hands => 1)
    create_hand
    session[:game_id] = @game.id

  end


  def create_hand

    active_hand = ActiveHand.new(:player_id => session[:player_id], :active_game => @game, :dealer => true)
    active_hand.save!

    @game.active_hand = active_hand

    @game.save!
    @game.active_hand.deal!
    session[:hand_id] = @game.active_hand.id

  end

  def check_for_old_hand
    if (!session[:game_id] && session[:hand_id])
      hand = ActiveHand.find(session[:hand_id]) if ActiveHand.where(:id => session[:hand_id]).present?
      hand.delete if hand
      session[:hand_id] = nil
    end
  end

end
