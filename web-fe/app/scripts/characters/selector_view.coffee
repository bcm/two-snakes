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
      this.listenTo @app, 'character:selected', (character) =>
        this.characterSelected(character)
      this.listenTo @app, 'character:unselected', (character) =>
        this.characterUnselected(character)

      @$el.html(CharactersTemplate)
      @$selections = @$el.find('#character-selections')

      characters = @app.characters()
      if characters.isEmpty()
        characters.once 'reset', (characters) =>
          this.renderCharacterSelectionViews(characters)
        characters.fetch(session: @app.session())
      else
        this.renderCharacterSelectionViews(characters)

      @accountNavView ?= new AccountNavView(@app)
      @accountNavView.render()

    enterWorld: =>
      if @selectedCharacter?
        @app.enterWorld(@selectedCharacter)
        this.replaceWithGameView()

    deleteCharacter: =>
      if @selectedCharacter?
        @selectedCharacter.once 'sync', =>
          @selectedCharacter = null
          @app.trigger "character:unselected", @selectedCharacter
          this.removeCharacterSelectionView(this.selectedView())
        @selectedCharacter.destroy(session: @app.session())

    selectedView: =>
      _.detect @characterSelectionViews, (v) => v.isSelected()

    showSelectedCharacterControls: =>
      @$el.find('[data-selection=character]').show()

    hideSelectedCharacterControls: =>
      @$el.find('[data-selection=character]').hide()

    enableSelectedCharacterControls: =>
      @$el.find('[data-selection=character]').removeClass('disabled')

    disableSelectedCharacterControls: =>
      @$el.find('[data-selection=character]').addClass('disabled')

    showNewCharacterView: =>
      @newCharacterView ?= new NewCharacterView(@app, this)
      @newCharacterView.render()

    renderCharacterSelectionViews: (characters) =>
      this.removeCharacterSelectionViews()
      characters.each (character) =>
        this.renderCharacterSelectionView(character)
      unless @app.characters().isEmpty()
        this.showSelectedCharacterControls()

    renderCharacterSelectionView: (character) =>
      view = new CharacterSelectionView(@app, this, @$selections, character)
      @characterSelectionViews.push(view)
      view.render()

    removeCharacterSelectionViews: =>
      this.removeCharacterSelectionView(view) for view in @characterSelectionViews

    removeCharacterSelectionView: (view) =>
      # XXX: makes a copy. need a real remove function.
      @characterSelectionViews = _.without @characterSelectionViews, view
      view.remove()

    characterSelected: (character) =>
      @selectedCharacter = character
      this.showSelectedCharacterControls()
      this.enableSelectedCharacterControls()

    characterUnselected: (character) =>
      @selectedCharacter = null
      this.disableSelectedCharacterControls()
      if @app.characters().isEmpty()
        this.hideSelectedCharacterControls()

    replaceWithGameView: =>
      this.remove()
      @app.router.navigate('play', trigger: true, replace: true)

    remove: =>  
      @accountNavView.remove() if @accountNavView?
      @newCharacterView.remove() if @newCharacterView?
      @$el.html('')
      this.stopListening()
      this
