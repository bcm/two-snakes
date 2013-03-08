define [
  'jquery',
  'underscore',
  'backbone',
  'account_nav_view'
], ($, _, Backbone, AccountNavView) ->
  'use strict'

  class GameView extends Backbone.View
    @_TEMPLATE = """
<input type="text" name="message" placeholder="type a message and press Enter" class='input-xxlarge'/>
<h3>Output</h3>
<ul id="output" class="unstyled"></ul>
"""
    constructor: (@app) ->
      @app.connectToWorldServer()
      @$el = $('#game')

    render: =>
      @$el.html(_.template(GameView._TEMPLATE, {}))

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

    remove: =>
      @accountNavView.remove() if @accountNavView
      super()
