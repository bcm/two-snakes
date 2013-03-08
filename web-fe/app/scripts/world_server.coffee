define [
  'jquery',
  'underscore',
  'backbone',
  'jquery_websocket'
], ($, _, Backbone) ->
  'use strict'

  class WorldServerMessage extends Backbone.Model
    sync: =>
      # overrides Backbone.sync to not perform the default behavior of sending an Ajax request

  class EchoMessage extends WorldServerMessage
    @TYPE: 'echo'

  class WorldServer extends Backbone.Model
    constructor: ->
      console.log "opening websocket connection"
      @socket = $.websocket('ws://127.0.0.1:8888/websocket/',
        open: ((e) =>
          console.log "connected to websocket server"
        ),
        close: ((e) =>
          console.log "disconnected from websocket server"
        ),
        events: {
          message: (e) =>
            message = this.createMessage(e.data)
            console.log "received message #{JSON.stringify message.toJSON()}"
            this.trigger "message:#{message.get('type')}", message
        }
      )

    sync: =>
      # overrides Backbone.sync to not perform the default behavior of sending an Ajax request

    createMessage: (attributes) =>
      switch attributes.type
        when EchoMessage.TYPE then new EchoMessage(attributes)
        else
          throw new TypeError("No world server message for type #{attributes.type}")

    sendMessage: (message) =>
      console.log "sending message #{JSON.stringify message.toJSON()}"
      @socket.send('message', message)
