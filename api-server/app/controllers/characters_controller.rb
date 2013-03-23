class CharactersController < ApplicationController
  def index
    characters = current_player.find_characters
    render_jsend(success: {characters: ActiveModel::ArraySerializer.new(characters).as_json})
  end

  def create
    character = current_player.build_character(character_params)
    if character.save
      render_jsend(success: CharacterSerializer.new(character).serializable_hash)
    else
      render_jsend(fail: character.errors)
    end
  end

  protected
    # XXX: replace with strong params
    def character_params
      params.slice(:name, :str, :dex, :con, :int, :wis, :cha)
    end
end
