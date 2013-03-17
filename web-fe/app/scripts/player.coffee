define [
  'jquery',
  'underscore',
  'backbone',
  'model',
  'character_collection'
], ($, _, Backbone, Model, CharacterCollection) ->
  'use strict'

  class Player extends Model
    initialize: (attributes = {}, options = {}) ->
      super(attributes, options)
      this.set('characters', new CharacterCollection)

    urlRoot: => 'http://localhost:5000/players'

    validate: (attributes, options) =>
      # XXX: add client-side validation
