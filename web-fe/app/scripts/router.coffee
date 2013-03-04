define [
  'jquery',
  'underscore',
  'backbone',
  'game_view'
], ($, _, Backbone, GameView) ->
  'use strict'

  class Router extends Backbone.Router
    constructor: (server) ->
      this.route '*anything', 'default', ->
        @gameView ?= new GameView(server)
        @gameView.render()

      Backbone.history.start()
