define [
  'jquery',
  'underscore',
  'backbone',
  'text!../account_nav.html'
], ($, _, Backbone, AccountNavTemplate) ->
  'use strict'

  class AccountNavView extends Backbone.View
    constructor: (@app) ->
      @$el = $('#account-nav')

      this.delegateEvents {
        'click [data-button=log-out]': 'logOut',
        'click [data-button=quit]': 'quit'
      }

    render: =>
      $tmpl = $(AccountNavTemplate)
      if @app.sessionManager.session.get('character')?
        $tmpl.find('[data-button=log-out]').parent().show()
      @$el.html($tmpl)
      this

    logOut: (e) =>
      e.preventDefault()
      @app.sessionManager.session.unset('character')
      @app.router.navigate('#logout', trigger: true)
      false

    quit: (e) =>
      e.preventDefault()
      @app.sessionManager.once 'session:end:success', =>
        # route doesn't actually exist, but it will force the login screen
        @app.router.navigate('#quit', trigger: true)
      @app.sessionManager.endSession()
      false

    remove: =>
      @$el.html('')
      this.stopListening()
      this
