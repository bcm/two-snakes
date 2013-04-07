"use strict"

class Characters extends Backbone.Router
  initialize: (@collection) ->
    @$el = $('#characters')

    this.route '', 'index'

  index: =>
    view = new CharacterSelector.Views.CharactersIndex(collection: @collection)
    this.swap(view)

  swap: (newView) =>
    if @currentView? and @currentView.remove?
      @currentView.remove()

    @currentView = newView
    @$el.empty().append(@currentView.render().el)

window.CharacterSelector.Routers.Characters = Characters
