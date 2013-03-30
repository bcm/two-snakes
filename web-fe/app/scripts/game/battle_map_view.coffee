define [
  'jquery',
  'underscore',
  'backbone',
  'text!../../game/battle_map.html'
], ($, _, Backbone, BattleMapTemplate) ->
  'use strict'

  class Grid
    @PX_HEIGHT = 500
    @PX_WIDTH = 500
    @PX_STEP = 50
    @LINE_COLOR = '#eee'

    constructor: (@context) ->

    draw: ->
      for x in [0.5..Grid.PX_WIDTH] by Grid.PX_STEP
        @context.moveTo(x, 0)
        @context.lineTo(x, Grid.PX_HEIGHT)

      for y in [0.5..Grid.PX_HEIGHT] by Grid.PX_STEP
        @context.moveTo(0, y)
        @context.lineTo(Grid.PX_WIDTH, y)

      @context.strokeStyle = Grid.LINE_COLOR
      @context.stroke()

  class BattleMapView extends Backbone.View
    constructor: (@app) ->

    render: =>
      @$el = $('#battle-map')
      @$el.html($(BattleMapTemplate))

      @canvas = @$el.find('canvas').get(0)
      @context = @canvas.getContext('2d')
      @grid = new Grid(@context)
      @grid.draw()

      this

    remove: =>
      @$el.html('')
      this.stopListening()
      this
