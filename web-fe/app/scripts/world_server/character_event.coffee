define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/event'
], ($, _, Backbone, WorldServerEvent) ->
  'use strict'

  class CharacterEvent extends WorldServerEvent
    constructor: (at, @characterRef) ->
      super(at)

    sentBy: (character) =>
      character.id is @characterRef.id
