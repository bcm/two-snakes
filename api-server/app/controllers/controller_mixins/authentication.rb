module ControllerMixins
  module Authentication
    extend ActiveSupport::Concern
    include ActionController::HttpAuthentication::Token::ControllerMethods
    include Sorcery::Controller

    included do
      helper_method :current_user, :logged_in?
      before_filter :require_login
    end

    protected
      def current_player
        current_user
      end

      def not_authenticated
        request_http_token_authentication("Two Snakes")
      end

      # overrides the HttpAuthentication::Token method to render a json response
      def request_http_token_authentication(realm, options = {})
        headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
        render(json: {status: 'error', code: 401, message: options.fetch(:message, 'Authentication required')})
      end

      # override the Sorcery method to short circuit other login source attempts
      def login_from_other_sources
        login_from_token_auth || false
      end

      def login_from_token_auth
        authenticate_with_http_token do |token|
          @current_user = user_class.authenticate_with_token(token)
          auto_login(@current_user) if @current_user
          @current_user
        end
      end
  end
end
