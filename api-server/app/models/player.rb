class Player < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation
  validates :email, presence: true, length: {minimum: 3, maximum: 255, allow_blank: true}
  validates :password, presence: true, length: {minimum: 3, maximum: 255, allow_blank: true},
            confirmation: {allow_blank: true}
  validates :password_confirmation, presence: true
end
