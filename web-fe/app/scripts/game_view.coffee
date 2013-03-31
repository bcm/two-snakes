define [
  'jquery',
  'underscore',
  'backbone',
  'text!../game.html',
  'alert_view',
  'account_nav_view',
  'game/character_pane_view',
  'game/battle_map_view'
  'world_server/chat_command'
], ($, _, Backbone, GameTemplate, AlertView, AccountNavView, CharacterPaneView, BattleMapView, ChatCommand) ->
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

      @battleMapView ?= new BattleMapView(@app)
      @battleMapView.render()

      @input = $('input[name=message]')
      @output = $('#output')

      @input.focus().on 'change', (e) =>
        # XXX: command interpreter component to parse the input, format it into a command and send it to the server
        @app.server.sendCommand(new ChatCommand(@input.val()))
        @input.val('')

      # XXX: chat pane subview
      # XXX: colorize system events
      this.listenTo @app.server, 'event:world-entered', (event) =>
        name = if event.sentBy(@app.character()) then 'You' else _.escape event.characterRef.name
        @output.append("<li>#{event.formattedAt()} #{name} logged in.</li>")
      this.listenTo @app.server, 'event:chat-say', (event) =>
        name = if event.sentBy(@app.character()) then 'You' else _.escape event.characterRef.name
        @output.append("<li>#{event.formattedAt()} #{name} said: #{_.escape event.text}</li>")
      this.listenTo @app.server, 'event:world-exited', (event) =>
        unless event.sentBy(@app.character())
          @output.append("<li>#{event.formattedAt()} #{_.escape event.characterRef.name} logged out.</li>")

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
      @battleMapView.remove() if @battleMapView
      @app.disconnectFromWorldServer()
      @$el.html('')
      this.stopListening()
      this
