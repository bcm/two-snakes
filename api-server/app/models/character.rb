require 'securerandom'

class Character < ActiveRecord::Base
  attr_accessible :name
  normalize_attributes :name

  validates :name, presence: true, length: {minimum: 2, maximum: 32, allow_blank: true},
            uniqueness: {case_sensitive: false}

  belongs_to :player

  def active_model_serializer
    CharacterSerializer
  end
end
