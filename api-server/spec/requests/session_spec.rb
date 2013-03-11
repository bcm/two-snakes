require 'spec_helper'

describe 'Session management' do
  it 'logs in a player submitting valid credentials' do
    password = Faker::Lorem.characters(12)
    player = Fabricate(:player, password: password, password_confirmation: password)
    post '/session', email: player.email, password: password
    expect(response).to be_jsend_success
    expect(response.jsend_data[:token]).to be
    player.reload
    expect(player.session_token).to eq(response.jsend_data[:token])
  end

  it 'returns an error to a player submitting invalid credentials' do
    password = Faker::Lorem.characters(12)
    player = Fabricate(:player, password: password, password_confirmation: password)
    post '/session', email: player.email, password: "#{password}-not"
    expect(response).to be_jsend_error
    expect(response.jsend_code).to eq(401)
    player.reload
    expect(player.session_token).to be_nil
  end

  it 'it logs out a logged-in player' do
    player = Fabricate(:player)
    player.reset_session_token
    delete '/session', nil, 'HTTP_AUTHORIZATION' => "Token token=\"#{player.session_token}\""
    expect(response).to be_jsend_success
    player.reload
    expect(player.session_token).to be_nil
  end
end
