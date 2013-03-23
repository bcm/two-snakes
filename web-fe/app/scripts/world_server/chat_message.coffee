define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/message'
], ($, _, Backbone, WorldServerMessage) ->
  'use strict'

  class ChatMessage extends WorldServerMessage
    constructor: (at, @text) ->
      super(at)
