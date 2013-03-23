define [
  'jquery',
  'underscore',
  'backbone',
  'world_server/command'
], ($, _, Backbone, WorldServerCommand) ->
  'use strict'

  class EnterWorldCommand extends WorldServerCommand
    @TYPE = 'enterworld'

    constructor: (@characterId) ->
      super()

    type: => EnterWorldCommand.TYPE

    data: => $.extend({characterId: @characterId}, super())
