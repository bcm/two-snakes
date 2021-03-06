define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/exit_world_command',
  'text!../account_nav.html'
], ($, _, Backbone, ExitWorldCommand, AccountNavTemplate) ->
  'use strict'

  class AccountNavView extends Backbone.View
    constructor: (@app) ->
      @$el = $('#account-nav')

      this.delegateEvents {
        'click [data-button=log-out]': (e) =>
          e.preventDefault()
          this.exitWorld()
          false
        'click [data-button=quit]': (e) =>
          e.preventDefault()
          this.quit()
          false
      }

    render: =>
      this.listenTo @app, 'session:end:success', this.replaceWithQuitView

      $tmpl = $(AccountNavTemplate)
      if @app.inWorld()
        $tmpl.find('[data-button=log-out]').parent().show()
      @$el.html($tmpl)
      this

    exitWorld: =>
      # XXX: delay for a few seconds so the player can cancel exiting
      @app.server.sendCommand(new ExitWorldCommand())
      @app.exitWorld()
      @app.router.navigate('#logout', trigger: true)

    quit: =>
      @app.server.sendCommand(new ExitWorldCommand())
      @app.quit()

    replaceWithQuitView: =>
      @app.router.navigate('#quit', trigger: true)

    remove: =>
      @$el.html('')
      this.stopListening()
      this
