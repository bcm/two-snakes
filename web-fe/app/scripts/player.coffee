define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  'use strict'

  # XXX: attach characters collection
  class Player extends Backbone.Model
    urlRoot: => 'http://localhost:5000/players'

    validate: (attributes, options) =>
      # XXX: add client-side validation
