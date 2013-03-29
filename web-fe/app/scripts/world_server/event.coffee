define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  'use strict'

  class WorldServerEvent
    constructor: (@at) ->
      if @at?
        if _.isNumber(@at)
          @at = new Date(@at)
        else if _.isString(@at)
          @at = new Date(Data.parse(@at))
        else
          # assume it's a Date
      else
        @at = new Date()

    formattedAt: =>
      unless @_formattedAt
        at = @at
        h = at.getHours()
        m = at.getMinutes()
        m = "0#{m}" if m < 10
        s = at.getSeconds()
        s = "0#{s}" if s < 10
        @_formattedAt = "#{h}:#{m}:#{s}"
      @_formattedAt
