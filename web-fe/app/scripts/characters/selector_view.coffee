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
          $char = $("""<li data-character="#{character.id}"><a>#{character.get('name')}</a></li>""")
          $char.on 'click', =>
            if $char.hasClass('active')
              $char.removeClass('active')
              $('[data-button=enter-world]').addClass('disabled')
            else
              @$characters.find('li[data-character]').removeClass('active')
              $char.addClass('active')
              $('[data-button=enter-world]').removeClass('disabled')
          @$characters.append($char)
        @$el.find('#enter').show()
      @app.sessionManager.session.get('player').get('characters').fetch(session: @app.sessionManager.session)

    showNewCharacterView: (e) =>
      e.preventDefault()
      @newCharacterView ?= new NewCharacterView(@app, this)
      @newCharacterView.render()
      false

    enterWorld: (e) =>
      e.preventDefault()
      return false if $(e.currentTarget).hasClass('disabled')
      selectedId = @$characters.find('li[data-character].active').data('character')
      if selectedId?
        selectedCharacter = @app.sessionManager.session.get('player').get('characters').
          find (char) => char.id is selectedId
        @app.sessionManager.session.set('character', selectedCharacter)
        this.replaceWithGameView()
      else
        console.log "No selected character"
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
