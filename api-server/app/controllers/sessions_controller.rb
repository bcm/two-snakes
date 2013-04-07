class SessionsController < ApplicationController
  skip_before_filter :require_login, except: :destroy

  def new
    @credentials = Credentials.new
  end

  def create
    @credentials = Credentials.new(credentials_params)
    if player = login(@credentials.email, @credentials.password)
      player.reset_session_token
      redirect_to(root_path)
    else
      flash.now[:error] = "Invalid credentials"
      render(:new)
    end
  end

  def destroy
    current_player.clear_session_token
    logout
    redirect_to(new_session_path)
  end

  private
    def credentials_params
      params.require(:credentials).permit(:email, :password)
    end
end
