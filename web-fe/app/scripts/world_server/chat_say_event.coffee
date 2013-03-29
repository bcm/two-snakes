define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/character_event'
], ($, _, Backbone, CharacterEvent) ->
  'use strict'

  class ChatSayEvent extends CharacterEvent
    constructor: (at, characterRef, @text) ->
      super(at, characterRef)
