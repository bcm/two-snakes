define [
  'jquery',
  'underscore',
  'backbone',
  'player'
], ($, _, Backbone, Player) ->
  'use strict'

  class SignupView extends Backbone.View
    @_TEMPLATE = """
<div class="modal hide" tabindex="-1" role="dialog" aria-labelledby="signup-label" aria-hidden="true">
  <form id="signup-form">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="signup-label">Sign up to play!</h3>
    </div>
    <div class="modal-body">
      <fieldset>
        <div class="control-group">
          <label class="control-label" for="signup-email">E-mail</label>
          <div class="controls">
            <input id="signup-email" type="email" class="input-xlarge" placeholder="me@example.com" maxlength="255"
                   required>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="signup-password">Password</label>
          <div class="controls">
            <input id="signup-password" type="password" class="input-xlarge" maxlength="128" required>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="signup-password-confirmation">Password (again)</label>
          <div class="controls">
            <input id="signup-password-confirmation" type="password" class="input-xlarge" maxlength="128" required>
          </div>
        </div>
      </fieldset>
    </div>
    <div class="modal-footer">
      <button class="btn btn-primary">Create your account</button>
      <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    </div>
  </form>
</div>
"""

    @_ERROR_TEMPLATE = """
<span class="help-inline"><%= message %></span>
"""

    constructor: (@app) ->
      @$el = $('#signup')

      this.delegateEvents {
        'submit #signup-form': 'signUp',
      }

    render: =>
      @$el.html(_.template(SignupView._TEMPLATE, {})) if @$el.is(':empty')
      @$modal ?= @$el.find('.modal')
      @$modal.modal('show')
      this

    signUp: =>
      this.clearModalErrors()
      player = new Player(
        email: @$el.find('#signup-email').val(),
        password: @$el.find('#signup-password').val(),
        passwordConfirmation: @$el.find('#signup-password-confirmation').val()
      )
      player.on 'invalid', (model, errors) =>
        this.showModalErrors(errors)
      player.save()
      false

    showModalErrors: (errors) =>
      this.showModalError(field, message) for own field, message of errors

    showModalError: (field, message) =>
      $input = @$modal.find("#signup-#{field}")
      $input.closest('.control-group').addClass('error')
      $input.closest('.controls').append(_.template(SignupView._ERROR_TEMPLATE, {message: message}))

    clearModalErrors: =>
      @$modal.find('.error').removeClass('error')
      @$modal.find('.help-inline').remove()
