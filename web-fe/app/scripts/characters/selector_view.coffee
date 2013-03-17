define [
  'jquery',
  'underscore',
  'backbone',
  'text!../../../characters/selector.html',
  'account_nav_view',
  'characters/new_view',
  'character_collection'
], ($, _, Backbone, CharactersTemplate, AccountNavView, NewCharacterView, CharacterCollection) ->
  'use strict'

  class CharacterSelectorView extends Backbone.View
    constructor: (@app) ->
      @$el = $('#characters')

      this.delegateEvents {
        'click [data-button=character-new]': 'showNewCharacterView',
        'click [data-button=enter-world]': 'enterWorld'
      }

      @accountNavView ?= new AccountNavView(@app)
      @accountNavView.render()

    render: =>
      @$el.html(CharactersTemplate)
      @$characters = @$el.find('#characters')

      this.listenTo @app.sessionManager.session.get('player').get('characters'), 'reset', (characters) =>
        @$characters.html('')
        characters.each (character) =>
        # XXX: should probably be a sub-view
          @$characters.append("""<li id="character-#{character.id}">#{character.get('name')}</li>""")
        @$el.find('#enter').show()
      @app.sessionManager.session.get('player').get('characters').fetch(session: @app.sessionManager.session)

    showNewCharacterView: (e) =>
      e.preventDefault()
      @newCharacterView ?= new NewCharacterView(@app, this)
      @newCharacterView.render()
      false

    enterWorld: (e) =>
      e.preventDefault()
      # XXX implement character selection
      # XXX ensure character selection is saved in local storage (attribute change event)
      # XXX send enter world event to world server
      selectedCharacter = @app.sessionManager.session.get('player').get('characters').at(0)
      @app.sessionManager.session.set('character', selectedCharacter)
      this.replaceWithGameView()
      false

    replaceWithGameView: =>
      this.remove()
      @app.router.navigate('play', trigger: true, replace: true)

    remove: =>  
      @accountNavView.remove() if @accountNavView?
      @newCharacterView.remove() if @newCharacterView?
      @$el.html('')
      this.stopListening()
      this
