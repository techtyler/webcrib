class ActiveGamesController < ApplicationController

  include ActionController::Live

  def show
    return if redirect_guest?

    find_game

    if !@game
      create_game
    end

    @hand = @game.active_hand
    gon.watch.rabl template: 'app/views/active_hands/hand.rabl', as: 'hand'

  end

  def new_game
    return if redirect_guest?

    find_game
    if @game
      #TODO: Forfeit by quitting/Surrender?
      @game.active_hand.delete
      @game.delete

    end

    redirect_to play_path
  end


  def new_hand
    return if redirect_guest?

    find_game
    if @game
      @game.active_hand.new_hand!
      @game.active_hand.deal!
    end

    redirect_to play_path
  end


  private
  def redirect_guest?

    if is_guest?
      redirect_to log_in_path, :notice => 'Please log in or sign up before playing.'
      return true
    end

  end

  def find_game
    @game = ActiveGame.find {|g| g.player_id == session[:player_id]}
  end

  def create_game

    @game = ActiveGame.new(:player_id => session[:player_id], :p1_score => 0, :p2_score => 0, :num_hands => 0)
    create_hand
    session[:game_id] = @game.id

  end

  def create_hand

    active_hand = ActiveHand.new(:player_id => session[:player_id], :active_game => @game, :dealer => true)
    active_hand.save!

    @game.active_hand = active_hand  #redundant first time but not second?

    @game.save!
    @game.active_hand.deal!       #TODO: Make deal an action by the user for all games except the first
    session[:hand_id] = @game.active_hand.id

  end


end
