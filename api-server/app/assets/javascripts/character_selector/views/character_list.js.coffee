"use strict"

class CharacterList extends CompositeView
  tagName: => 'ul'
  className: => 'nav nav-list'

  render: =>
    @$el.empty()
    @collection.each (character) =>
      choice = new CharacterSelector.Views.CharacterChoice(model: character)
      this.appendChildTo(choice, @$el)
    this

window.CharacterSelector.Views.CharacterList = CharacterList
