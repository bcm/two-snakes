class SessionsController < ApplicationController
  skip_before_filter :require_login, except: :destroy

  def new
    @player = Player.new
  end

  def create
    if @player = login(params[:email], params[:password])
      player.reset_session_token
      redirect_to(characters_path)
    else
      render(:new)
    end
  end

  def destroy
    logout
    current_player.clear_session_token
    redirect_to(:new)
  end
end
