define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  'use strict'

  class AlertView extends Backbone.View
    @_TEMPLATE = """
<div class="alert alert-block">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
  <%= message %>
</div>
"""

    constructor: (@$el, @message, options = {}) ->
      @level = options.level or 'success'
      @fade = options.fade or false

    render: =>
      @$alert = $(_.template(AlertView._TEMPLATE, {message: @message}))
      @$alert.addClass("alert-#{@level}")
      @$alert.delay(5000).fadeOut('slow') if @fade
      @$alert.on 'closed', =>
        $(this).remove()
      @$el.prepend(@$alert)
      this

    close: =>
      @$alert.alert('close') if @$alert?
