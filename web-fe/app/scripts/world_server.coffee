define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/enter_world_command',
  'world_server/chat_say_event',
  'world_server/world_entered_event',
  'world_server/world_exited_event',
  'jquery_websocket'
], ($, _, Backbone, EnterWorldCommand, ChatSayEvent, WorldEnteredEvent, WorldExitedEvent) ->
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
            this.trigger "event:chat-say", new ChatSayEvent(e.data)
          'world-entered': (e) =>
            this.trigger "event:world-entered", new WorldEnteredEvent(e.data)
          'world-exited': (e) =>
            this.trigger "event:world-exited", new WorldExitedEvent(e.data)

    sync: =>
      # overrides Backbone.sync to not perform the default behavior of sending an Ajax request

    sendCommand: (message) =>
      @socket.send(message.type(), message.data())

    disconnect: =>
      @socket.close() if @socket?
