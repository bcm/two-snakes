define [
  'jquery',
  'underscore',
  'backbone',
  'credentials',
  'alert_view'
], ($, _, Backbone, Credentials, AlertView) ->
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

    render: =>
      @$el.html(_.template(LoginView._TEMPLATE, {}))
      this

    logIn: =>
      credentials = new Credentials

      this.listenTo credentials, 'request', =>
        @alertView.close() if @alertView?

      this.listenTo credentials, 'loginSuccess', (token) =>
        @app.startSession(token)
        this.remove()
        @app.router.navigate('game', trigger: true, replace: true)

      this.listenTo credentials, 'loginFailure', =>
        @alertView = new AlertView(@$el, "Login failed", level: 'error')
        @alertView.render()

      credentials.save {
        email: @$el.find('#email').val(),
        password: @$el.find('#password').val()
      }

      false
