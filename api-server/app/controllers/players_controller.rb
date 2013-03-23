class PlayersController < ApplicationController
  skip_before_filter :require_login, only: :create

  def create
    player = Player.new(player_params)
    if player.save
      player.reset_session_token # log the player in
      render_jsend(success: PlayerSerializer.new(player).serializable_hash)
    else
      render_jsend(fail: player.errors)
    end
  end

  protected
    def player_params
      params.permit(:email, :password, :password_confirmation)
    end
end
