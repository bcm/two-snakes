define [
  'jquery',
  'underscore',
  'backbone',
  'router',
  'world_server',
  'bootstrap',
  'backbone_jsend'
], ($, _, Backbone, Router, WorldServer) ->
  'use strict'

  class TwoSnakes
    constructor: ->
      @router = new Router(this)

    connectToWorldServer: =>
      @server = new WorldServer
