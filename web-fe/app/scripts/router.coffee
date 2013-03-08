define [
  'jquery',
  'underscore',
  'backbone',
  'login_view',
  'game_view'
], ($, _, Backbone, LoginView, GameView) ->
  'use strict'

  class Router extends Backbone.Router
    constructor: (@app) ->
      this.route '*anything', 'login', ->
        @loginView ?= new LoginView
        @loginView.render()

      this.route 'game', 'game', ->
        @gameView ?= new GameView(@app)
        @gameView.render()

      Backbone.history.start()
