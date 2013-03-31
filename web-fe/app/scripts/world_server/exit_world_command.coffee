define [
  'jquery',
  'world_server/command'
], ($, WorldServerCommand) ->
  'use strict'

  class ExitWorldCommand extends WorldServerCommand
    @TYPE = 'exitworld'

    constructor: (@characterId) ->
      super()

    type: => ExitWorldCommand.TYPE

    data: => $.extend({characterId: @characterId}, super())
