define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/enter_world_command',
  'world_server/chat_say_event',
  'world_server/world_entered_event',
  'jquery_websocket'
], ($, _, Backbone, EnterWorldCommand, ChatSayEvent, WorldEnteredEvent) ->
  'use strict'

  class WorldServer
    constructor: (@app, @options = {}) ->
      _.extend(this, Backbone.Events)

    connect: =>
      @socket = $.websocket 'ws://127.0.0.1:8888/websocket/',
        open: (e) =>
          this.sendCommand(new EnterWorldCommand(@app.sessionManager.session.get('character').id))
        events:
          'chat-say': (e) =>
            this.trigger "message:chat-say", new ChatSayEvent(e.data.at, e.data.character, e.data.text)
          'world-entered': (e) =>
            this.trigger "message:world-entered", new WorldEnteredEvent(e.data.at, e.data.character)

    sync: =>
      # overrides Backbone.sync to not perform the default behavior of sending an Ajax request

    sendCommand: (message) =>
      @socket.send(message.type(), message.data())

    disconnect: =>
      @socket.close() if @socket?
