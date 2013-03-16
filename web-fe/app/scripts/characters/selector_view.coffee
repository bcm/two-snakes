define [
  'jquery',
  'underscore',
  'backbone',
  'text!../../../characters/selector.html',
  'characters/new_view',
  'character_collection'
], ($, _, Backbone, CharactersTemplate, NewCharacterView, CharacterCollection) ->
  'use strict'

  class CharacterSelectorView extends Backbone.View
    constructor: (@app) ->
      @$el = $('#characters')

      this.delegateEvents {
        'click [data-button=character-new]': 'showNewCharacterView',
        'click [data-button=enter-world]': 'enterWorld'
      }

    render: =>
      @$el.html(CharactersTemplate)
      @$characters = @$el.find('#characters')

      # XXX: get collection from session player
      # XXX: fails on first load because session token is undefined
      @characters ?= new CharacterCollection()
      # use on instead of listenTo so the handlers don't get wiped out when the view is removed
      @characters.on 'reset', (characters) =>
        @$characters.html('')
        characters.each (character) =>
        # XXX: should probably be a sub-view
          @$characters.append("""<li id="character-#{character.id}">#{character.get('name')}</li>""")
        @$el.find('#enter').show()

      @characters.fetch(session: @app.sessionManager.session)

    showNewCharacterView: (e) =>
      e.preventDefault()
      @newCharacterView ?= new NewCharacterView(@app, this)
      @newCharacterView.render()
      false

    enterWorld: (e) =>
      e.preventDefault()
      selectedCharacter = @characters.at(0)
      @app.sessionManager.character = selectedCharacter
      this.replaceWithGameView()
      false

    replaceWithGameView: =>
      this.remove()
      @app.router.navigate('play', trigger: true, replace: true)

    remove: =>
      @newCharacterView.remove() if @newCharacterView?
      @$el.html('')
      this.stopListening()
      this
