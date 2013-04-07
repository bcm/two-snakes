class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

#  rescue_from Exception do |e|
#    logger.error("#{e.class}: #{e.message}")
#    e.backtrace.each { |f| logger.error("  #{f}") }
#    render_jsend(error: e.message, code: 500)
#  end

  before_filter :require_login, except: :not_authenticated

  private
    def not_authenticated
      redirect_to(new_session_path, alert: "Please login first.")
    end
end
