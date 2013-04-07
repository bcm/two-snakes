class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :require_login, except: :not_authenticated
  helper_method :current_user

  private
    def current_player
      current_user
    end

    def not_authenticated
      redirect_to(new_session_path)
    end
end
