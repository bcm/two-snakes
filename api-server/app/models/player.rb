require 'securerandom'

class Player < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation
  validates :email, presence: true, length: {minimum: 3, maximum: 255, allow_blank: true}
  validates :password, presence: true, length: {minimum: 3, maximum: 255, allow_blank: true},
            confirmation: {allow_blank: true}, on: :create
  validates :password_confirmation, presence: true, on: :create

  def reset_session_token
    token = self.class.generate_session_token
    update_attributes!({session_token: token}, without_protection: true, validate: false)
    token
  end

  def clear_session_token
    update_attributes!({session_token: nil}, without_protection: true, validate: false)
    nil
  end

  def self.authenticate_with_token(token)
    find_by_session_token(token)
  end

  def self.generate_session_token
    # thanks Devise
    loop do
      token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
      break token unless where(session_token: token).first
    end
  end
end
