define [
  'jquery',
  'underscore',
  'backbone',
  'alert_view'
], ($, _, Backbone, AlertView) ->
  'use strict'

  class LoginView extends Backbone.View
    @_TEMPLATE = """
<div class="alert alert-block" style="display:none">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
</div>
<form class="form-inline">
  <input id="email" type="text" class="input-large" placeholder="Email">
  <input id="password" type="password" class="input-large" placeholder="Password">
  <button type="submit" class="btn">Log in</button>
</form>
"""

    constructor: (@app) ->
      @$el = $('#login')

      this.delegateEvents {
        'submit form': 'logIn'
      }

      this.listenTo @app.sessionManager, 'session:start:success', this.replaceWithGameView
      this.listenTo @app.sessionManager, 'session:start:failure', this.showLoginFailedAlert

    render: =>
      @$el.html(_.template(LoginView._TEMPLATE, {}))
      this

    logIn: =>
      this.clearAlert()
      @app.sessionManager.startSession(@$el.find('#email').val(), @$el.find('#password').val())
      false

    replaceWithGameView: =>
      this.remove()
      @app.router.navigate('game', trigger: true, replace: true)

    showLoginFailedAlert: =>
      this.clearAlert()
      @alertView = new AlertView(@$el, "Login failed", level: 'error')
      @alertView.render()

    clearAlert: =>
      @alertView.close() if @alertView?
      @alertView = null
