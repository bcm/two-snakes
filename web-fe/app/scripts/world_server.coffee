define [
  'jquery',
  'underscore',
  'backbone',
  'jquery_websocket'
], ($, _, Backbone) ->
  'use strict'

  class WorldServerMessage extends Backbone.Model
    initialize: (attributes = {}, options = {}) ->
      super(attributes, options)
      # XXX: needs to account for skew between client and server clocks
      this.set('at', new Date())

    formattedAt: =>
      unless @_formattedAt?
        at = this.get('at')
        h = at.getHours()
        m = at.getMinutes()
        m = "0#{m}" if m < 10
        s = at.getSeconds()
        s = "0#{s}" if s < 10
        @_formattedAt = "#{h}:#{m}:#{s}"
      @_formattedAt

    sync: =>
      # overrides Backbone.sync to not perform the default behavior of sending an Ajax request

  # XXX: it's not clear that message subtypes serve any real purpose

  class ChatMessage extends WorldServerMessage
    @TYPE: 'chat'

  class EnterWorldMessage extends WorldServerMessage
    @TYPE: 'enterworld'

  class WorldServer extends Backbone.Model
    constructor: (@app, @options = {}) ->

    connect: =>
      @socket = $.websocket 'ws://127.0.0.1:8888/websocket/',
        open: (e) =>
          this.sendMessage(this.createMessage(
            type: 'enterworld', characterId: @app.sessionManager.session.get('character').id))
        events:
          message: (e) =>
            # XXX: server will eventually send a chat message in response to an enterworld message
            if e.data.type is 'enterworld'
              e.data.type = 'chat'
              e.data.text = 'Welcome to the world of Two Snakes!'
            message = this.createMessage(e.data)
            console.log "received message", message
            this.trigger "message:#{message.get('type')}", message

    sync: =>
      # overrides Backbone.sync to not perform the default behavior of sending an Ajax request

    createMessage: (attributes) =>
      switch attributes.type
        when ChatMessage.TYPE then new ChatMessage(attributes)
        when EnterWorldMessage.TYPE then new EnterWorldMessage(attributes)
        else
          throw new TypeError("No world server message for type #{attributes.type}")

    sendMessage: (message) =>
      console.log "sending message", message
      @socket.send('message', message)

    disconnect: =>
      @socket.close() if @socket?
