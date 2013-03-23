define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  'use strict'

  class WorldServerCommand
    constructor: ->
      # XXX: needs to account for skew between client and server clocks
      @at = new Date()

    data: => {at: @at.getTime()}
