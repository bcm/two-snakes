"use strict"

class Characters extends SwappableRouter
  initialize: (@characters) ->
    @$el = $('#characters')

    this.route '', 'index'

  index: =>
    view = new CharacterSelector.Views.CharacterList(collection: @characters)
    this.swap(view)

window.CharacterSelector.Routers.Characters = Characters
