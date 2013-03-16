define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  'use strict'

  class AccountNavView extends Backbone.View
    @_TEMPLATE = """
<ul class="nav">
  <li><a id="logout" href="#logout">Log out</a></li>
</ul>
"""

    constructor: (@app) ->
      @$el = $('#account-nav')

    render: =>
      @$el.html(AccountNavView._TEMPLATE)
      this
