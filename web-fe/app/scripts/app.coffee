define [
  'jquery',
  'underscore',
  'backbone',
  'router',
  'world_server',
  'session_manager',
  'bootstrap',
  'backbone_jsend'
], ($, _, Backbone, Router, WorldServer, SessionManager) ->
  'use strict'

  class TwoSnakes
    constructor: ->
      _.extend(this, Backbone.Events)

      @sessionManager = new SessionManager(this)
      @sessionManager.resumeSession()
      @server = new WorldServer(this)
      @router = new Router(this)

    logIn: (email, password) =>
      @sessionManager.startSession(email, password)

    logInThroughTheBackDoor: (player) =>
      @sessionManager.initSession(player)

    quit: =>
      @sessionManager.endSession()

    session: =>
      @sessionManager.session

    player: =>
      this.session().get('player')

    characters: =>
      player = this.player()
      if player? then player.get('characters') else null

    enterWorld: (character) =>
      this.session().set('character', character)

    exitWorld: =>
      this.session().unset('character') if this.session()?

    inWorld: =>
      this.character()?

    character: =>
      this.session().get('character')

    connectToWorldServer: =>
      @server.connect()

    disconnectFromWorldServer: =>
      @server.disconnect()
