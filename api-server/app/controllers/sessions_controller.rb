class SessionsController < ApplicationController
  skip_before_filter :require_login, only: :create

  def create
    if user = login(params[:email], params[:password])
      user.reset_session_token
      render(json: {status: 'success', data: {token: user.session_token}})
    else
      request_http_token_authentication("Two Snakes", message: "Authentication failed")
    end
  end

  def destroy
    logout
    current_player.clear_session_token
    render(json: {status: 'success', data: nil})
  end
end
