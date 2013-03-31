define [
  'jquery',
  'underscore',
  'backbone',
  'grid',
  'text!../../game/battle_map.html'
], ($, _, Backbone, Grid, BattleMapTemplate) ->
  'use strict'

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
