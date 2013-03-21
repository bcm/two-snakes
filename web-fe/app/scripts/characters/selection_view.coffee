define [
  'jquery',
  'underscore',
  'backbone',
  'text!../../../characters/selection.html'
], ($, _, Backbone, CharacterSelectionTemplate) ->
  'use strict'

  class CharacterSelectionView extends Backbone.View
    constructor: (@app, @$container, @character) ->
      @$el = $(CharacterSelectionTemplate)

      this.delegateEvents {
        'click a': 'selectCharacter'
      }

    render: =>
      @$el.data('character', @character.id)
      @$el.find('a').html(@character.get('name'))
      @$container.append(@$el)

    selectCharacter: (e) =>
      if this.isSelected()
        this.unselect()
      else
        this.select()

    isSelected: =>
      @$el.hasClass('active')

    select: =>
      @$el.addClass('active')
      @$el.trigger 'character:selected'

    unselect: =>
      @$el.removeClass('active')
      @$el.trigger 'character:unselected'
