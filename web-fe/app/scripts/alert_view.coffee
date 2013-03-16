define [
  'jquery',
  'underscore',
  'backbone',
  'text!../alert.html'
], ($, _, Backbone, AlertTemplate) ->
  'use strict'

  class AlertView extends Backbone.View
    @_TEMPLATE = """
<div class="alert alert-block">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
</div>
"""

    constructor: (@$el, @message, options = {}) ->
      @level = options.level or 'success'
      @fade = options.fade or false

    render: =>
      @$alert = $(AlertTemplate)
      @$alert.append(@message)
      @$alert.addClass("alert-#{@level}")
      @$alert.delay(5000).fadeOut('slow') if @fade
      @$alert.on 'closed', =>
        $(this).remove()
      @$el.prepend(@$alert)
      this

    close: =>
      @$alert.alert('close') if @$alert?

    remove: =>
      # don't remove from dom or stop listening because @$el is borrowed from the parent view
      this