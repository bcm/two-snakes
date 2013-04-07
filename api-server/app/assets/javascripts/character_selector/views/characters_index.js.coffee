"use strict"

class CharactersIndex extends Backbone.View
  tagName: => 'ul'
  className: => 'nav nav-list'

  render: =>
    @collection.each (character) =>
      @$el.append("<li>#{character.escape('name')}</li>")
    this

window.CharacterSelector.Views.CharactersIndex = CharactersIndex
