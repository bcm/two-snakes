define [
  'jquery',
  'underscore',
  'backbone',
  'character',
  'collection'
], ($, _, Backbone, Character, Collection) ->
  'use strict'

  class CharacterCollection extends Collection
    initialize: (models = [], options = {}) ->
      @model = Character
      @url = 'http://localhost:5000/characters'

    parse: (response, options) =>
      response.characters
