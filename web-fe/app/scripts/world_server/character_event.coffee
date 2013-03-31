define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/event'
], ($, _, Backbone, WorldServerEvent) ->
  'use strict'

  class CharacterEvent extends WorldServerEvent
    constructor: (attributes) ->
      @characterRef = attributes.character
      super(attributes)

    sentBy: (character) =>
      character.id is @characterRef.id
