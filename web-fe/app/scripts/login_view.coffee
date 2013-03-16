define [
  'jquery',
  'underscore',
  'backbone',
  'text!../login.html',
  'alert_view',
  'signup_view'
], ($, _, Backbone, LoginTemplate, AlertView, SignupView) ->
  'use strict'

  class LoginView extends Backbone.View
    constructor: (@app) ->
      @$el = $('#login')

      this.delegateEvents {
        'submit #login-form': 'logIn',
        'click [data-button=signup]': 'signUp'
      }

      this.listenTo @app.sessionManager, 'session:start:success', this.replaceWithGameView
      this.listenTo @app.sessionManager, 'session:start:failure', this.showLoginFailedAlert

    render: =>
      @$el.html(LoginTemplate)
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
