require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(:default, Rails.env)
end

$stdout.sync = true

module ApiServer
  class Application < Rails::Application
    config.time_zone = 'Pacific Time (US & Canada)'
    config.i18n.default_locale = :en
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.active_record.schema_format = :sql
    config.active_record.whitelist_attributes = true
    config.assets.enabled = false
    config.middleware.use Rack::Cors do
      allow do
        origins 'http://localhost:9000'
        resource '*', headers: :any, methods: [:get, :put, :post, :patch, :delete]
      end
    end
  end
end
