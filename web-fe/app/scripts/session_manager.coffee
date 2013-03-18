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
    constructor: ->
      _.extend(this, Backbone.Events)

    startSession: (email, password) =>
      session = this._createSession(email: email, password: password)
      session.once 'change', =>
        localStorage.setItem('twosnakes.session.player', JSON.stringify(session.get('player')))
        @session = session
        this.trigger 'session:start:success', @session
      session.once 'sync:error', =>
        this.trigger 'session:start:failure'
      session.save()

    initSession: (playerAttrs) =>
      localStorage.setItem('twosnakes.session.player', JSON.stringify(playerAttrs))
      player = new Player(playerAttrs)
      @session = this._createSession(id: player.get('sessionToken'), player: player)

    resumeSession: =>
      playerAttrs = localStorage.getItem('twosnakes.session.player')
      player = new Player(JSON.parse(playerAttrs)) if playerAttrs?
      characterAttrs = localStorage.getItem('twosnakes.session.character')
      character = new Character(JSON.parse(characterAttrs)) if characterAttrs?
      if player?
        session = this._createSession(id: player.get('sessionToken'), player: player, character: character)
        this.trigger 'session:resume:success', session
        @session = session
      else
        this.trigger 'session:resume:failure'
        null

    endSession: =>
      @session.once 'sync', (data) =>
        localStorage.removeItem('twosnakes.session.player')
        localStorage.removeItem('twosnakes.session.character')
        @session = null
        this.trigger 'session:end:success', @session
      @session.once 'sync:error', =>
        this.trigger 'session:end:failure'
      @session.destroy()

    _createSession: (attrs) =>
      session = new Session(attrs)
      session.on 'change:character', (session, character) =>
        if character?
          localStorage.setItem('twosnakes.session.character', JSON.stringify(character))
        else
          localStorage.removeItem('twosnakes.session.character')
      session
