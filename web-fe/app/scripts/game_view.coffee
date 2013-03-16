define [
  'jquery',
  'underscore',
  'backbone',
  'text!../game.html',
  'alert_view',
  'account_nav_view'
], ($, _, Backbone, GameTemplate, AlertView, AccountNavView) ->
  'use strict'

  class GameView extends Backbone.View
    constructor: (@app) ->
      @app.connectToWorldServer()
      @$el = $('#game')

    render: =>
      @$el.html(GameTemplate)

      @accountNavView ?= new AccountNavView(@app)
      @accountNavView.render()

      @input = $('input[name=message]')
      @output = $('#output')

      @input.focus().on 'change', (e) =>
        @app.server.sendMessage(@app.server.createMessage({type: 'echo', text: @input.val()}))
        @input.val('')

      # XXX: should probably be a sub-view
      this.listenTo @app.server, 'message:echo', (message) =>
        @output.append("<li>#{message.get('text')}</li>")

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
      super()
