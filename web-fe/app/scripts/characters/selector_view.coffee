define [
  'jquery',
  'underscore',
  'backbone',
  'text!../../../characters/selector.html',
  'account_nav_view',
  'characters/new_view',
  'characters/selection_view'
], ($, _, Backbone, CharactersTemplate, AccountNavView, NewCharacterView, CharacterSelectionView) ->
  'use strict'

  class CharacterSelectorView extends Backbone.View
    constructor: (@app) ->
      @$el = $('#characters')
      @characterSelectionViews = []

      this.delegateEvents {
        'click [data-button=character-new]': (e) =>
          e.preventDefault()
          this.showNewCharacterView()
          false
        'click [data-button=enter-world]': (e) =>
          e.preventDefault()
          this.enterWorld()
          false
        'click [data-button=character-delete]': (e) =>
          e.preventDefault()
          # XXX: prompt for confirmation
          this.deleteCharacter()
          false
      }

    render: =>
      @$el.html(CharactersTemplate)
      @$selections = @$el.find('#character-selections')

      characters = @app.sessionManager.session.get('player').get('characters')
      characters.once 'reset', (characters) =>
        this.showCharacterSelectionViews(characters)
        unless characters.isEmpty()
          @$el.find('[data-selection=character]').show()
      characters.fetch(session: @app.sessionManager.session)

      @accountNavView ?= new AccountNavView(@app)
      @accountNavView.render()

    showNewCharacterView: =>
      @newCharacterView ?= new NewCharacterView(@app, this)
      @newCharacterView.render()

    enterWorld: =>
      character = this.selectedCharacter()
      if character?
        @app.sessionManager.session.set('character', character)
        this.replaceWithGameView()

    deleteCharacter: =>
      character = this.selectedCharacter()
      if character?
        character.once 'sync', =>
          view = this.selectedView()
          this.characterViewUnselected(view)
          view.remove()
        character.destroy(session: @app.sessionManager.session)

    selectedView: =>
      _.detect @characterSelectionViews, (v) => v.isSelected()

    selectedCharacter: =>
      selectedView = this.selectedView()
      if selectedView?
        @app.sessionManager.session.get('player').get('characters').detect (char) => char is selectedView.character

    showCharacterSelectionViews: (characters) =>
      view.remove() for view in @characterSelectionViews
      characters.each (character) =>
        this.showCharacterSelectionView(character)

    showCharacterSelectionView: (character) =>
      view = new CharacterSelectionView(@app, this, @$selections, character)
      @characterSelectionViews.push(view)
      view.$el.on 'character:selected', =>
        this.characterViewSelected(view)
      view.$el.on 'character:unselected', =>
        this.characterViewUnselected(view)
      view.render()

    characterViewSelected: (view) =>
      otherViews = _.reject @characterSelectionViews, (v) => v.$el.is(view.$el)
      _.each otherViews, (v) => v.$el.removeClass('active')
      @$el.find('[data-selection=character]').removeClass('disabled')

    characterViewUnselected: (view) =>
      @$el.find('[data-selection=character]').addClass('disabled')
      characters = @app.sessionManager.session.get('player').get('characters')
      if characters.isEmpty()
        @$el.find('[data-selection=character]').hide()

    replaceWithGameView: =>
      this.remove()
      @app.router.navigate('play', trigger: true, replace: true)

    remove: =>  
      @accountNavView.remove() if @accountNavView?
      @newCharacterView.remove() if @newCharacterView?
      @$el.html('')
      this.stopListening()
      this
