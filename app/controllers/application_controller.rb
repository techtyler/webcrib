class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_player
  helper_method :is_guest?


  private
  def is_guest?

    !session[:player_id]
  end

  def current_player

    @current_player ||= (CribPlayer.find(session[:player_id]) if session[:player_id])

  end

end
