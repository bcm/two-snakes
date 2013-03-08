define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  'use strict'

  # XXX: unify Session and Credentials so that destroying a session calls the logout api

  class Session extends Backbone.Model
    constructor: (@token) ->

    sync: =>
