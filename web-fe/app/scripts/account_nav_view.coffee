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
      # XXX: only show log out option when game is in session (player exists)

    render: =>
      @$el.html(AccountNavTemplate)
      this

    remove: =>
      @$el.html('')
      this.stopListening()
      this
