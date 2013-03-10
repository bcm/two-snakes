require 'spec_helper'

describe Player do
  it 'fails validation with no email' do
    expect(Player.new).to have(1).error_on(:email)
  end

  it 'fails validation with short email' do
    expect(Player.new(email: 'a')).to have(1).error_on(:email)
  end

  it 'fails validation with long email' do
    expect(Player.new(email: 'a'*256)).to have(1).error_on(:email)
  end

  it 'passes validation with an email' do
    expect(Player.new(email: 'foo@example.com')).to have(:no).errors_on(:email)
  end

  it 'fails validation on create with no password' do
    expect(Player.new).to have(1).error_on(:password)
  end

  it 'fails validation on create with short password' do
    expect(Player.new(password: 'a')).to have(1).error_on(:password)
  end

  it 'fails validation on create with long password' do
    expect(Player.new(password: 'a'*256)).to have(1).error_on(:password)
  end

  it 'passes validation on create with a password' do
    expect(Player.new(password: '123abc')).to have(:no).errors_on(:password)
  end

  it 'fails validation on create with no password confirmation' do
    expect(Player.new).to have(1).error_on(:password_confirmation)
  end

  it 'passes validation on create with a password confirmation' do
    expect(Player.new(password_confirmation: '123abc')).to have(:no).errors_on(:password_confirmation)
  end

  it 'fails validation on create with password not confirmed' do
    expect(Player.new(password: '123abc', password_confirmation: 'abc123')).to have(1).error_on(:password)
  end

  it 'passes validation on create with password confirmed' do
    expect(Player.new(password: '123abc', password_confirmation: '123abc')).to have(:no).errors_on(:password)
  end

  it 'passes validation on update with no password' do
    player = Fabricate(:player)
    player.password = nil
    expect(player).to have(:no).errors_on(:password)
  end

  it 'passes validation on update with no password confirmation' do
    player = Fabricate(:player)
    player.password_confirmation = nil
    expect(player).to have(:no).errors_on(:password_confirmation)
  end

  it 'resets the session token' do
    old_token = Faker::Lorem.characters(20)
    player = Fabricate(:player)
    player.session_token = old_token
    player.save!
    player.reset_session_token
    expect(player.session_token).to be
    expect(player.session_token).to_not eq(old_token)
  end

  it 'clears the session token' do
    player = Fabricate(:player)
    player.session_token = Faker::Lorem.characters(20)
    player.save!
    player.clear_session_token
    expect(player.session_token).to be_nil
  end

  it 'authenticates a player given a session token' do
    token = Faker::Lorem.characters(20)
    player = Fabricate(:player)
    player.session_token = token
    player.save!
    expect(Player.authenticate_with_token(token)).to eq(player)
  end

  it 'generates a unique session token' do
    # don't use faker to generate base64 results for this test because occasionally it generates strings with
    # characters that get rewritten by the tr() in Player::generate_session_token.
    player = Fabricate(:player)
    player.session_token = 'abc123'
    player.save!
    SecureRandom.stub(:base64).and_return('abc123', 'foobar')
    expect(Player.generate_session_token).to eq('foobar')
  end
end
