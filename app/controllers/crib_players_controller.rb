class CribPlayersController < ApplicationController
  def new
    @player = CribPlayer.new
  end

  def create
    @player = CribPlayer.new(player_params)
    if @player.save
      redirect_to root_url, :notice => 'Signed up!'
    else
      flash[:alert] = 'Please fill out the form correctly.'
      render 'new'
    end
  end

  def player_params
    params.require(:crib_player).permit(:username, :email, :password, :password_confirmation)
  end
end
