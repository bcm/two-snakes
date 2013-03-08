define [
  'jquery',
  'underscore',
  'backbone',
  'login_view',
  'game_view'
], ($, _, Backbone, LoginView, GameView) ->
  'use strict'

  class Router extends Backbone.Router
    constructor: ->
      this.route '*anything', 'login', ->
        @loginView ?= new LoginView
        @loginView.render()

      this.route 'game', 'game', ->
        @server ?= new WorldServer
        @gameView ?= new GameView(server)
        @gameView.render()

      Backbone.history.start()
