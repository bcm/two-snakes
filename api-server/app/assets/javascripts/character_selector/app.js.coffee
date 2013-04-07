"use strict"

class CharacterSelectorApp
  constructor: (data = {}) ->
    @characters = new CharacterSelector.Collections.Characters(data.characters)
    @charactersRouter = new CharacterSelector.Routers.Characters(@characters)

    unless Backbone.history.started
      Backbone.history.start()
      Backbone.history.started = true

window.CharacterSelector =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

jQuery ->
  $div = $('<div></div>');
  $div.html($('#data').text())
  data = JSON.parse($div.text())

  CharacterSelector.App = new CharacterSelectorApp(data)
