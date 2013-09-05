class SessionsController < ApplicationController

  def new

  end

  def create

    if !params[:email]
      render 'new'
      return
    end

    player = CribPlayer.find_by_email(params[:email])

    if player && player.authenticate(params[:password])
      flash[:notice] = 'Logged in!'
      session[:player_id] = player.id
      redirect_to root_url
    else
      flash[:alert] = 'Invalid email or password.'
      render 'new'
    end
  end

  def destroy
    session[:player_id] = nil
    redirect_to root_url, :notice => 'Logged out.'
  end
end
