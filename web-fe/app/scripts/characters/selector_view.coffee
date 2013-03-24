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
      }

    render: =>
      @$el.html(CharactersTemplate)
      @$selections = @$el.find('#character-selections')
      @$enterWorldControl = @$el.find('#enter')
      @$enterWorldButton = @$enterWorldControl.find('[data-button=enter-world]')

      characters = @app.sessionManager.session.get('player').get('characters')
      characters.once 'reset', (characters) =>
        this.showCharacterSelectionViews(characters)
        if characters.length > 0
          this.showEnterWorldControl()
      characters.fetch(session: @app.sessionManager.session)

      @accountNavView ?= new AccountNavView(@app)
      @accountNavView.render()

    showNewCharacterView: =>
      @newCharacterView ?= new NewCharacterView(@app, this)
      @newCharacterView.render()

    enterWorld: =>
      return if @$enterWorldButton.hasClass('disabled')
      selectedView = _.detect @characterSelectionViews, (v) => v.isSelected()
      if selectedView?
        selectedCharacter = @app.sessionManager.session.get('player').get('characters').
          detect (char) => char is selectedView.character
        @app.sessionManager.session.set('character', selectedCharacter)
        this.replaceWithGameView()
      else
        console.log "No selected character"

    showCharacterSelectionViews: (characters) =>
      view.remove() for view in @characterSelectionViews
      characters.each (character) =>
        this.showCharacterSelectionView(character)

    showCharacterSelectionView: (character) =>
      view = new CharacterSelectionView(@app, this, @$selections, character)
      @characterSelectionViews.push(view)
      view.$el.on 'character:selected', =>
        otherViews = _.reject @characterSelectionViews, (v) => v.$el.is(view.$el)
        _.each otherViews, (v) => v.$el.removeClass('active')
        @$enterWorldButton.removeClass('disabled')
      view.$el.on 'character:unselected', =>
        @$enterWorldButton.addClass('disabled')
      view.render()

    showEnterWorldControl: =>
      @$enterWorldControl.show()

    replaceWithGameView: =>
      this.remove()
      @app.router.navigate('play', trigger: true, replace: true)

    remove: =>  
      @accountNavView.remove() if @accountNavView?
      @newCharacterView.remove() if @newCharacterView?
      @$el.html('')
      this.stopListening()
      this
