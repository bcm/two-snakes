define [
  'jquery',
  'underscore',
  'backbone',
  'text!../../../characters/selection.html'
], ($, _, Backbone, CharacterSelectionTemplate) ->
  'use strict'

  class CharacterSelectionView extends Backbone.View
    constructor: (@app, @characterSelectorView, @$container, @character) ->
      @$el = $(CharacterSelectionTemplate)

      timeout = null
      delay = 100

      this.delegateEvents {
        'click a': (e) =>
          timeout = setTimeout((=>
            e.preventDefault()
            timeout = null
            this.selectCharacter()
            false
          ), delay)
        'dblclick a': (e) =>
          if timeout
            clearTimeout(timeout)
            timeout = null
          e.preventDefault()
          this.enterWorld()
          false
      }

      this.listenTo @app, 'character:selected', (character) =>
        this.characterSelected(character)

    render: =>
      @$el.data('character', @character.id)
      @$el.find('a').html(@character.get('name'))
      @$container.append(@$el)

    selectCharacter: =>
      if this.isSelected()
        this.unselect()
      else
        this.select()

    enterWorld: =>
      @app.enterWorld(@character)
      this.replaceWithGameView()

    isSelected: =>
      @$el.hasClass('active')

    select: =>
      @$el.addClass('active')
      @app.trigger 'character:selected', @character

    unselect: =>
      @$el.removeClass('active')
      @app.trigger 'character:unselected', @character

    characterSelected: (selected) =>
      # responds to character:selected triggered by other view instances. always call select() or unselect() to
      # trigger that event in addition to setting selection state.
      if _.isEqual(selected, @character)
        @$el.addClass('active')
      else
        @$el.removeClass('active')

    replaceWithGameView: =>
      @characterSelectorView.remove()
      @app.router.navigate('play', trigger: true, replace: true)
