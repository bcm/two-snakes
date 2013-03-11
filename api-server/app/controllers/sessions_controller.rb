class SessionsController < ApplicationController
  skip_before_filter :require_login, only: :create

  def create
    if player = login(params[:email], params[:password])
      player.reset_session_token
      render_jsend(success: {token: player.session_token})
    else
      request_http_token_authentication("Two Snakes", message: "Authentication failed")
    end
  end

  def destroy
    logout
    current_player.clear_session_token
    render_jsend(:success)
  end
end
