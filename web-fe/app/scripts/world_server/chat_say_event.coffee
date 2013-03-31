define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/character_event'
], ($, _, Backbone, CharacterEvent) ->
  'use strict'

  class ChatSayEvent extends CharacterEvent
    constructor: (attributes) ->
      @text = attributes.text
      super(attributes)
