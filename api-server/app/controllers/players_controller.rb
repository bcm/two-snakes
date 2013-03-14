class PlayersController < ApplicationController
  skip_before_filter :require_login, only: :create

  def create
    player = Player.new(player_params)
    if player.save
      player.reset_session_token # log the player in
      # XXX: use AS::Serializers
      render_jsend(success: player.attributes)
    else
      render_jsend(fail: player.errors)
    end
  end

  protected
    def player_params
      params.slice(:email, :password, :password_confirmation)
    end
end
