Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:5500'
    resource '*', headers: :any, methods: [:get, :patch]
  end
end