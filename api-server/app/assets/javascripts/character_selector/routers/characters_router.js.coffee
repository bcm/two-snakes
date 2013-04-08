"use strict"

class Characters extends SwappableRouter
  initialize: (@characters) ->
    this.route '', 'index'

  index: =>
    view = new CharacterSelector.Views.CharactersIndex(collection: @characters)
    view.render()

window.CharacterSelector.Routers.Characters = Characters
