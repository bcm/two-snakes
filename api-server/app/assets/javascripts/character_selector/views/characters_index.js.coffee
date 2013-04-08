"use strict"

class CharactersIndex extends CompositeView
  render: =>
    list = new CharacterSelector.Views.CharacterList(collection: @collection)
    this.renderChildInto(list, $('#characters'))
    this

window.CharacterSelector.Views.CharactersIndex = CharactersIndex
