define [
  'jquery',
  'underscore',
  'backbone',
  'session',
  'player',
  'character'
], ($, _, Backbone, Session, Player, Character) ->
  'use strict'

  class SessionManager
    constructor: (@app) ->

    # XXX: return tri-state promise (success, failure, error) from save, resume, destroy

    startSession: (email, password) =>
      session = this._createSession(email: email, password: password)
      session.once 'change', =>
        localStorage.setItem('twosnakes.session.player', JSON.stringify(session.get('player')))
        @session = session
        @app.trigger 'session:start:success', @session
      session.once 'sync:error', =>
        @app.trigger 'session:start:failure'
      session.save()

    initSession: (player) =>
      sessionToken = player.get('sessionToken')
      localStorage.setItem('twosnakes.session.player', JSON.stringify(player))
      @session = this._createSession(id: sessionToken, player: player)

    resumeSession: =>
      playerAttrs = localStorage.getItem('twosnakes.session.player')
      player = new Player(JSON.parse(playerAttrs)) if playerAttrs?
      characterAttrs = localStorage.getItem('twosnakes.session.character')
      character = new Character(JSON.parse(characterAttrs)) if characterAttrs?
      if player?
        session = this._createSession(id: player.get('sessionToken'), player: player, character: character)
        @app.trigger 'session:resume:success', session
        @session = session
      else
        @app.trigger 'session:resume:failure'
        null

    endSession: =>
      @session.once 'sync', (data) =>
        localStorage.removeItem('twosnakes.session.player')
        localStorage.removeItem('twosnakes.session.character')
        @session = null
        @app.trigger 'session:end:success', @session
      @session.once 'sync:error', =>
        @app.trigger 'session:end:failure'
      @session.destroy()

    _createSession: (attrs) =>
      session = new Session(attrs)
      session.on 'change:character', (session, character) =>
        if character?
          localStorage.setItem('twosnakes.session.character', JSON.stringify(character))
        else
          localStorage.removeItem('twosnakes.session.character')
      session
