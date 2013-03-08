define [
  'jquery',
  'underscore',
  'backbone',
  'router',
  'world_server',
  'session',
  'bootstrap',
  'backbone_jsend'
], ($, _, Backbone, Router, WorldServer, Session) ->
  'use strict'

  class TwoSnakes
    constructor: ->
      this.resumeSession()
      @router = new Router(this)

    connectToWorldServer: =>
      @server = new WorldServer

    startSession: (token) =>
      @session = new Session(token)
      localStorage.setItem('twosnakes.session.token', @session.token)

    resumeSession: =>
      token = localStorage.getItem('twosnakes.session.token')
      @session = new Session(token) if token?

    endSession: =>
      @session.destroy()
      @session = null
      localStorage.removeItem('twosnakes.session.token')
      console.log 'session ended'