define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/chat_message',
  'world_server/enter_world_command',
  'jquery_websocket'
], ($, _, Backbone, ChatMessage, EnterWorldCommand) ->
  'use strict'

  class WorldServer
    constructor: (@app, @options = {}) ->
      _.extend(this, Backbone.Events)

    connect: =>
      @socket = $.websocket 'ws://127.0.0.1:8888/websocket/',
        open: (e) =>
          this.sendCommand(new EnterWorldCommand(@app.sessionManager.session.get('character').id))
        events:
          chat: (e) =>
            this.trigger "message:chat", new ChatMessage(e.data.at, e.data.text)

    sync: =>
      # overrides Backbone.sync to not perform the default behavior of sending an Ajax request

    sendCommand: (message) =>
      @socket.send(message.type(), message.data())

    disconnect: =>
      @socket.close() if @socket?
