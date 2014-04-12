class CribPlayersController < ApplicationController
  def new
    @player = CribPlayer.new
  end

  def create
    @player = CribPlayer.new(player_params)
    @player.save

    player_stat = PlayerStat.new(:crib_player => @player, :games_played => 0,
    :games_won => 0,
    :skunks => 0,
    :lowest_ai_score => 121)

    player_stat.save
    @player.player_stat = player_stat


    if @player.save
      session[:player_id] = @player.id
      redirect_to root_url, :notice => 'Signed up!'
    else
      flash[:alert] = 'Please fill out the form correctly.' #TODO Give reasons why it didnt work
      render 'new'
    end
  end

  def player_params
    params.require(:crib_player).permit(:username, :email, :password, :password_confirmation)
  end
end
