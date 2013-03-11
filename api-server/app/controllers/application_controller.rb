class ApplicationController < ActionController::API
  include JSend::Rails::Controller
  include ControllerMixins::Authentication
end
