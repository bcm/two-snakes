define [
  'jquery',
  'underscore',
  'backbone',
  'alert_view',
  'signup_view'
], ($, _, Backbone, AlertView, SignupView) ->
  'use strict'

  class LoginView extends Backbone.View
    @_TEMPLATE = """
<div class="alert alert-block" style="display:none">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
</div>
<form id="login-form" class="form-inline">
  <input id="email" type="email" class="input-large" placeholder="E-mail">
  <input id="password" type="password" class="input-large" placeholder="Password">
  <button type="submit" class="btn">Log in</button>
  or
  <button data-button="signup" class="btn">Sign up</button>
</form>
<div id="signup"></div>
"""

    constructor: (@app) ->
      @$el = $('#login')

      this.delegateEvents {
        'submit #login-form': 'logIn',
        'click [data-button=signup]': 'signUp'
      }

      this.listenTo @app.sessionManager, 'session:start:success', this.replaceWithGameView
      this.listenTo @app.sessionManager, 'session:start:failure', this.showLoginFailedAlert

    render: =>
      @$el.html(LoginView._TEMPLATE)
      this

    logIn: =>
      this.clearAlert()
      @app.sessionManager.startSession(@$el.find('#email').val(), @$el.find('#password').val())
      false

    signUp: =>
      this.clearAlert()
      this.showSignupView()
      false

    showSignupView: =>
      @signupView ?= new SignupView(@app, this)
      @signupView.render()

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

    remove: =>
      @alertView.remove() if @alertView?
      @signupView.remove() if @signupView?
      super()
