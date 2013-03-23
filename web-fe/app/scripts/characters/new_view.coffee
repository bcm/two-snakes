define [
  'jquery',
  'underscore',
  'backbone',
  'text!../../../characters/new.html',
  'text!../../../form_inline_error.html'
  'character',
  'die'
], ($, _, Backbone, NewCharacterTemplate, FormErrorTemplate, Character, Die) ->
  'use strict'

  class NewCharacterView extends Backbone.View
    constructor: (@app, @characterSelectorView) ->

    render: =>
      @$el = $('#character-new')
      @character = new Character({}, collection: @app.sessionManager.session.get('player').get('characters'))

      this.delegateEvents {
        'click [data-button=roll]': (e) =>
          e.preventDefault()
          this.rollAbilityScores()
          false
        'submit #character-new-form': (e) =>
          e.preventDefault()
          this.createCharacter()
          false
      }

      @$el.html($(NewCharacterTemplate))
      this.rollAbilityScores()

      @$modal = @$el.find('.modal')
      @$modal.modal('show')

      this

    rollAbilityScores: =>
      for ability in ["str", "dex", "con", "int", "wis", "cha"]
        @$el.find("#character-new-#{ability}").html(Die.roll(4, 6, dropLowest: 1))

    createCharacter: (e) =>
      this.clearModalErrors()
      @character.once 'sync:success', (character) =>
        this.remove()
        @characterSelectorView.render()
      @character.once 'sync:failure', (errors) =>
        this.showModalErrors(errors)
      @character.on 'invalid', (model, errors) =>
        this.showModalErrors(errors)
      @character.save({
        name: @$el.find('#character_name').val(),
        str: @$el.find('#character-new-str').text(),
        dex: @$el.find('#character-new-dex').text(),
        con: @$el.find('#character-new-con').text(),
        int: @$el.find('#character-new-int').text(),
        wis: @$el.find('#character-new-wis').text(),
        cha: @$el.find('#character-new-cha').text(),
      }, session: @app.sessionManager.session)

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
      if @$modal?
        @$modal.modal('hide')
        @$modal = null
      @character = null if @character?
      @$el.html('')
      this.stopListening()
      this

