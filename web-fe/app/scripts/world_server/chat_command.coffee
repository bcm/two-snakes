define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/command'
], ($, _, Backbone, WorldServerCommand) ->
  'use strict'

  class ChatCommand extends WorldServerCommand
    @TYPE = 'chat'

    constructor: (@text) ->
      super()

    type: => ChatCommand.TYPE

    data: => $.extend({text: @text}, super())
