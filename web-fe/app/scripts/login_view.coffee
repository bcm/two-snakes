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
        'submit #login-form': (e) =>
          e.preventDefault()
          this.logIn()
          false
        'click [data-button=signup]': (e) =>
          e.preventDefault()
          this.showSignUpView()
          false
      }

    render: =>
      this.listenTo @app, 'session:start:success', this.replaceWithCharacterSelectorView
      this.listenTo @app, 'session:start:failure', this.showLoginFailedAlert

      @$el.html(LoginTemplate)
      this

    logIn: =>
      this.clearAlert()
      @app.logIn(@$el.find('#email').val(), @$el.find('#password').val())
      false

    showSignUpView: =>
      this.clearAlert()
      @signupView ?= new SignupView(@app, this)
      @signupView.render()
      false

    replaceWithCharacterSelectorView: =>
      this.remove()
      @app.router.navigate('characters', trigger: true, replace: true)

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
      @$el.html('')
      this.stopListening()
      this
