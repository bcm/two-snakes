define [
  'underscore'
], (_) ->
  'use strict'

  class GridSquare
    constructor: (@x, @y) ->

    toString: =>
      "#{@x},#{@y}"
