module RequestAuth
  shared_context 'logged in' do
    let!(:password) { Faker::Lorem.characters(12) }
    let!(:player) { Fabricate(:player, password: password, password_confirmation: password) }

    before do
      post '/session', email: player.email, password: password
      @session_token = response.jsend_data[:sessionToken]
    end

    def xhr(request_method, path, parameters = {}, headers = {})
      headers['HTTP_AUTHORIZATION'] ||= "Token token=\"#{@session_token}\""
      super(request_method, path, parameters, headers)
    end
  end
end

RSpec.configure do |config|
  config.include RequestAuth, type: :request
end
