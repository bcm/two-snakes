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
      @app.sessionManager.session.set('character', @character)
      this.replaceWithGameView()

    isSelected: =>
      @$el.hasClass('active')

    select: =>
      @$el.addClass('active')
      @$el.trigger 'character:selected'

    unselect: =>
      @$el.removeClass('active')
      @$el.trigger 'character:unselected'

    replaceWithGameView: =>
      @characterSelectorView.remove()
      @app.router.navigate('play', trigger: true, replace: true)
