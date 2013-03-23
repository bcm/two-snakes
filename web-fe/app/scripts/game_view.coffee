define [
  'jquery',
  'underscore',
  'backbone',
  'text!../game.html',
  'alert_view',
  'account_nav_view',
  'game/character_pane_view',
  'world_server/chat_command'
], ($, _, Backbone, GameTemplate, AlertView, AccountNavView, CharacterPaneView, ChatCommand) ->
  'use strict'

  class GameView extends Backbone.View
    constructor: (@app) ->
      @$el = $('#game')

    render: =>
      @$el.html(GameTemplate)

      @accountNavView ?= new AccountNavView(@app)
      @accountNavView.render()

      @characterPaneView ?= new CharacterPaneView(@app)
      @characterPaneView.render()

      @input = $('input[name=message]')
      @output = $('#output')

      @input.focus().on 'change', (e) =>
        # XXX: command interpreter component to parse the input, format it into a command and send it to the server
        @app.server.sendCommand(new ChatCommand(@input.val()))
        @input.val('')

      # XXX: chat pane subview
      # XXX: colorize system messages
      this.listenTo @app.server, 'message:chat', (message) =>
        @output.append("<li>#{message.formattedAt()} #{_.escape message.text}</li>")

      @app.connectToWorldServer()

    showAlert: (message, options = {}) =>
      this.clearAlert()
      @alertView = new AlertView(@$el, message, options)
      @alertView.render()

    clearAlert: =>
      @alertView.close() if @alertView?
      @alertView = null

    remove: =>
      @alertView.remove() if @alertView?
      @accountNavView.remove() if @accountNavView?
      @characterPaneView.remove() if @characterPaneView?
      @app.disconnectFromWorldServer()
      @$el.html('')
      this.stopListening()
      this
