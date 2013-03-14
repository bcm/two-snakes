class ApplicationController < ActionController::API
  include JSend::Rails::Controller
  include ControllerMixins::Authentication

  rescue_from Exception do |e|
    logger.error("#{e.class}: #{e.message}")
    e.backtrace.each { |f| logger.error("  #{f}") }
    render_jsend(error: e.message, code: 500)
  end
end
