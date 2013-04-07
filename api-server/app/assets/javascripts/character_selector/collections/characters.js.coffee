"use strict"

class Characters extends Backbone.Collection
  initialize: (models, options) =>
    @model = CharacterSelector.Models.Character

  comparator: (a, b) =>
    a.get('name').toLowerCase().localeCompare(b.get('name').toLowerCase())

window.CharacterSelector.Collections.Characters = Characters
