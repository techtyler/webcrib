class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_player
  helper_method :is_guest?
  helper_method :retrieve_active_hand?
  helper_method :mobile_device?
  helper_method :redirect_guest?

  add_flash_types :game

  private

  def redirect_guest?

    if is_guest?
      redirect_to log_in_path, :notice => 'Please log in or sign up before playing.'
      return true
    end

  end

  def new_game_message(msg)
    if flash[:game]
      flash[:game] << msg
    else
      flash[:game] = [msg]
    end
  end

  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message

    flash.discard
    flash[:game] = ['clear']
  end

  def flash_message
    messages = []
    [:warning, :notice].each do |type|
      messages << flash[type] unless flash[type].blank?
    end
    unless flash[:game].blank?
      flash[:game].each do |msg|
        messages << msg
      end
    end

    return messages.join '::'


  end


  # def mobile_device?
  #
  #   if session[:mobile_param]
  #     session[:mobile_param] == '1'
  #   else
  #     request.user_agent =~ /Mobile|webOS/
  #   end
  #
  #
  # end
  #
  # def prepare_for_mobile
  #   session[:mobile_param] = params[:mobile] if params[:mobile]
  # end


  def is_guest?
    !current_player
  end

  def current_player

    #TODO If you can't find that player_id (browser stayed open during a database reset, reset it to nil and tell them to log in again)

    unless @current_player
      if (session[:player_id] && CribPlayer.where(id: session[:player_id]).present?)
        @current_player = CribPlayer.find(session[:player_id])
      else
        session[:player_id] = nil #This will reset the now invalid player id
      end
    else
      return @current_player  #Is this redundant?
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
