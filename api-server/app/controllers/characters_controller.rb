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

  def destroy
    current_player.find_character(params[:id]).destroy
    render_jsend(:success)
  end

  protected
    def character_params
      params.permit(:name, :str, :dex, :con, :int, :wis, :cha)
    end
end
