"use strict"

class CharacterList extends CompositeView
  tagName: => 'ul'
  className: => 'nav nav-list'

  render: =>
    @$el.empty()
    @collection.each (character) =>
      child = new CharacterSelector.Views.CharacterChoice(model: character)
      this.renderChildInto(child, this.el)
    this

window.CharacterSelector.Views.CharacterList = CharacterList
