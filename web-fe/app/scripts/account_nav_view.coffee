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

    render: =>
      $tmpl = $(AccountNavTemplate)
      if @app.sessionManager.character?
        $tmpl.find('#logout').parent().show()
      @$el.html($tmpl)
      this

    remove: =>
      @$el.html('')
      this.stopListening()
      this
