"use strict"

class Characters extends SwappableRouter
  initialize: (@characters) ->
    this.route '', 'index'
    this.route 'new', 'newCharacter'

  index: =>
    view = new CharacterSelector.Views.CharactersIndex(collection: @characters)
    view.render()

  newCharacter: =>
    view = new CharacterSelector.Views.NewCharacter(collection: @characters, el: '#new-character-modal')
    view.render()

window.CharacterSelector.Routers.Characters = Characters
