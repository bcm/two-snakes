define [
  'jquery',
  'underscore',
  'backbone',
  'text!../../../characters/new.html',
  'text!../../../form_inline_error.html'
  'character'
], ($, _, Backbone, NewCharacterTemplate, FormErrorTemplate, Character) ->
  'use strict'

  class NewCharacterView extends Backbone.View
    constructor: (@app, @characterSelectorView) ->
      @$el = $('#character-new')

      this.delegateEvents {
        'submit #character-new-form': 'createCharacter',
      }

    render: =>
      @$el.html(NewCharacterTemplate) if @$el.is(':empty')
      @$modal ?= @$el.find('.modal')
      @$modal.modal('show')
      this

    createCharacter: (e) =>
      e.preventDefault()
      this.clearModalErrors()
      character = new Character({
        name: @$el.find('#character_name').val(),
      }, collection: @characterSelectorView.characters)
      # XXX: get collection from session player
      character.once 'sync:success', (character) =>
        this.remove()
        @characterSelectorView.render()
      character.once 'sync:failure', (errors) =>
        this.showModalErrors(errors)
      character.on 'invalid', (model, errors) =>
        this.showModalErrors(errors)
      character.save({}, session: @app.sessionManager.session)
      false

    # XXX: abstract modal stuff
    showModalErrors: (errors) =>
      this.showModalError(field, message) for own field, message of errors

    showModalError: (field, message) =>
      $input = @$modal.find("#character_#{field}")
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
