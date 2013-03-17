define [
  'jquery',
  'underscore',
  'backbone',
  'session'
], ($, _, Backbone, Session) ->
  'use strict'

  class SessionManager
    constructor: ->
      _.extend(this, Backbone.Events)

    startSession: (email, password) =>
      session = new Session(email: email, password: password)
      session.once 'session:saved', (data) =>
        @session = session
        this.trigger 'session:start:success', session
      session.once 'sync:error', =>
        this.trigger 'session:start:failure'
      session.save()

    initSession: (player) =>
      @session = Session.init(player)

    resumeSession: =>
      session = Session.resume()
      if session?
        this.trigger 'session:resume:success', session
        @session = session
      else
        this.trigger 'session:resume:failure'
        null

    endSession: =>
      @session.once 'session:destroyed', (data) =>
        @session = null
        this.trigger 'session:end:success', @session
      @session.once 'sync:error', =>
        this.trigger 'session:end:failure'
      @session.destroy()
