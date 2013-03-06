class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include Sorcery::Controller

  helper_method :current_user, :logged_in?
  before_filter :require_login

  # XXX: add token-based authentication as per ActionController::HttpAuthentication::Token

  protected
    def not_authenticated
      render(json: {status: 'fail', data: 'Not authenticated'})
    end
end
