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
      this.route '*anything', 'default', =>
        this.navigate('play', trigger: true, replace: true)

      this.route 'play', 'play', =>
        @gameView ?= new GameView(@app)
        @gameView.render()

      this.route 'logout', 'logout', =>
        @app.endSession()
        @gameView.remove() if @gameView
        this.navigate('', replace: true)
        location.reload()

      Backbone.history.start()

    route: (route, name, callback) =>
      # in order to force withSession behavior for all routes, duplicate the superclass behavior of calling the named
      # method on the router if a callback isn't provided
      super route, name, =>
        this.withSession =>
          if callback?
            callback()
          else
            this[name].apply(this)

    # Execute the given function only if the app has an established session. Otherwise force the player to log in.
    withSession: (func) =>
      if @app.session
        func() if func?
      else
        # don't trigger the default route because it causes the browser to enter an endless loop for some reason I
        # haven't figured out yet. just update the url and then render the login view.
        this.navigate('', replace: true)
        @loginView ?= new LoginView(@app)
        @loginView.render()
