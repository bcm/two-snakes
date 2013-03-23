class CharacterSerializer < ActiveModel::Serializer
  attributes :id, :name, :str, :dex, :con, :int, :wis, :cha
end
