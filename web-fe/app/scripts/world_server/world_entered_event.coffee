define [
  'jquery',
  'underscore',
  'backbone',
  'grid_square',
  'world_server/character_event'
], ($, _, Backbone, GridSquare, CharacterEvent) ->
  'use strict'

  class WorldEnteredEvent extends CharacterEvent
    constructor: (attributes) ->
      @location = new GridSquare(attributes.location.x, attributes.location.y)
      super(attributes)
