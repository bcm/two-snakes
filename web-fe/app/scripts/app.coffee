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
      @sessionManager = new SessionManager
      @sessionManager.resumeSession()
      @router = new Router(this)

    connectToWorldServer: =>
      @server = new WorldServer
