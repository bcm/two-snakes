define [
  'jquery',
  'underscore',
  'backbone',
  'text!../signup.html',
  'text!../form_inline_error.html'
  'player'
], ($, _, Backbone, SignupTemplate, FormErrorTemplate, Player) ->
  'use strict'

  class SignupView extends Backbone.View
    constructor: (@app, @loginView) ->
      @$el = $('#signup')

      this.delegateEvents {
        'submit #signup-form': 'signUp',
      }

    render: =>
      @$el.html(SignupTemplate) if @$el.is(':empty')
      @$modal ?= @$el.find('.modal')
      @$modal.modal('show')
      this

    signUp: (e) =>
      e.preventDefault()
      this.clearModalErrors()
      player = new Player(
        email: @$el.find('#signup_email').val(),
        password: @$el.find('#signup_password').val(),
        password_confirmation: @$el.find('#signup_password_confirmation').val()
      )
      player.once 'sync:success', (player) =>
        this.app.sessionManager.initSession(player)
        @loginView.replaceWithCharacterView()
        this.app.router.characterView.showAlert("Welcome #{player.email}!", fade: true)
      player.once 'sync:failure', (errors) =>
        this.showModalErrors(errors)
      player.on 'invalid', (model, errors) =>
        this.showModalErrors(errors)
      player.save()
      false

    showModalErrors: (errors) =>
      this.showModalError(field, message) for own field, message of errors

    showModalError: (field, message) =>
      $input = @$modal.find("#signup_#{field}")
      $input.closest('.control-group').addClass('error')
      $error = $(FormErrorTemplate)
      $error.text(message)
      $input.closest('.controls').append($error)

    clearModalErrors: =>
      @$modal.find('.error').removeClass('error')
      @$modal.find('.help-inline').remove()

    remove: =>
      @$modal.modal('hide') if @$modal?
      super()
