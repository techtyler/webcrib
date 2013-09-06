class ActiveGamesController < ApplicationController

  include ActionController::Live



  def show
    return if redirect_guest?

    @game = ActiveGame.find {|g| g.player_id == session[:player_id]}

    if !@game
      new_game
      @game.active_hand.deal!   #should this move to the active_hands controller (click to deal?)
    end

    session[:hand_id] = @game.active_hand.id  #TODO: make sure this is necessary
  end


  private
  def redirect_guest?

    if is_guest?
      redirect_to log_in_path, :notice => 'Please log in or sign up before playing.'
      return true
    end

  end

  def new_game

    @game = ActiveGame.new(:player_id => session[:player_id], :p1_score => 0, :p2_score => 0, :num_hands => 0)
    active_hand = ActiveHand.new(:player_id => session[:player_id], :active_game => @game, :dealer => true)

    active_hand.save!
    @game.save!

  end

  def events

  end

end
