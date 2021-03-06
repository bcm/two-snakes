define [
  'jquery',
  'underscore',
  'backbone',
  'login_view',
  'characters/selector_view',
  'game_view'
], ($, _, Backbone, LoginView, CharacterSelectorView, GameView) ->
  'use strict'

  class Router extends Backbone.Router
    constructor: (@app) ->
      this.route '*anything', 'default', =>
        if @app.sessionManager.session? and @app.sessionManager.session.get('character')?
          this.navigate('play', trigger: true, replace: true)
        else
          # will force login if there's no session
          this.navigate('characters', trigger: true, replace: true)

      this.route 'characters', 'characters', =>
        @characterSelectorView ?= new CharacterSelectorView(@app)
        @characterSelectorView.render()

      this.route 'play', 'play', =>
        @gameView ?= new GameView(@app)
        @gameView.render()

      this.route 'logout', 'logout', =>
        @gameView.remove() if @gameView?
        this.navigate('characters', trigger: true, replace: true)

      this.route 'quit', 'quit', =>
        @characterSelectorView.remove() if @characterSelectorView?
        @gameView.remove() if @gameView?
        # force login
        this.navigate('characters', trigger: true, replace: true)

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
      if @app.sessionManager.session?
        func() if func?
      else
        # don't trigger the default route because it causes the browser to enter an endless loop for some reason I
        # haven't figured out yet. just update the url and then render the login view.
        @characterSelectorView.remove() if @characterSelectorView?
        @gameView.remove() if @gameView?
        this.navigate('', replace: true)
        @loginView ?= new LoginView(@app)
        @loginView.render()
