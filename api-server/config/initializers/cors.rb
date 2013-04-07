Rails.application.config.middleware.use Rack::Cors do
  allow do
    origins 'http://localhost:9000'
    resource '*', headers: :any, methods: [:get, :put, :post, :patch, :delete]
  end
end
