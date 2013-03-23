define [
  'jquery',
  'underscore',
  'backbone',
  'text!../../game/character_pane.html'
], ($, _, Backbone, CharacterPaneTemplate) ->
  'use strict'

  class CharacterPaneView extends Backbone.View
    constructor: (@app) ->

    render: =>
      @$el = $('#character-pane')
      $tmpl = $(CharacterPaneTemplate)
      character = @app.sessionManager.session.get('character')
      $tmpl.find('#character-name').html(character.get('name'))
      $tmpl.find('#character-str').html(character.get('str'))
      $tmpl.find('#character-dex').html(character.get('dex'))
      $tmpl.find('#character-con').html(character.get('con'))
      $tmpl.find('#character-int').html(character.get('int'))
      $tmpl.find('#character-wis').html(character.get('wis'))
      $tmpl.find('#character-cha').html(character.get('cha'))
      @$el.html($tmpl)
      this

    remove: =>
      @$el.html('')
      this.stopListening()
      this
