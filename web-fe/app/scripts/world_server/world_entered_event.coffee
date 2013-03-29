define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/character_event'
], ($, _, Backbone, CharacterEvent) ->
  'use strict'

  class WorldEnteredEvent extends CharacterEvent
