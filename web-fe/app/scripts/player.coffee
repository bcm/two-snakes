define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  'use strict'

  class Player extends Backbone.Model
    urlRoot: => 'http://localhost:5000/session/players'

    validate: (attributes, options) =>
      # XXX: add client-side validation
