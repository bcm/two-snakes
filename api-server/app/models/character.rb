require 'securerandom'

class Character < ActiveRecord::Base
  attr_accessible :name, :str, :dex, :con, :int, :wis, :cha
  normalize_attributes :name

  validates :name, presence: true, length: {minimum: 2, maximum: 32, allow_blank: true},
            uniqueness: {case_sensitive: false}
  validates :str, presence: true, numericality: {only_integer: true, allow_blank: true}
  validates :dex, presence: true, numericality: {only_integer: true, allow_blank: true}
  validates :con, presence: true, numericality: {only_integer: true, allow_blank: true}
  validates :int, presence: true, numericality: {only_integer: true, allow_blank: true}
  validates :wis, presence: true, numericality: {only_integer: true, allow_blank: true}
  validates :cha, presence: true, numericality: {only_integer: true, allow_blank: true}

  belongs_to :player

  def active_model_serializer
    CharacterSerializer
  end
end
