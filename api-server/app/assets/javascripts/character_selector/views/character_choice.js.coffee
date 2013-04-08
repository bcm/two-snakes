"use strict"

class CharacterChoice extends Backbone.View
  tagName: => 'li'

  render: =>
    @$el.text(@model.escape('name'))

window.CharacterSelector.Views.CharacterChoice = CharacterChoice
