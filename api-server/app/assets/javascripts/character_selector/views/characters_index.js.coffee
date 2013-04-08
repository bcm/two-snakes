"use strict"

class CharactersIndex extends CompositeView
  initialize: (options) =>

  render: =>
    list = new CharacterSelector.Views.CharacterList(collection: @collection)
    this.renderChildInto(list, $('#characters'))
    this

window.CharacterSelector.Views.CharactersIndex = CharactersIndex
