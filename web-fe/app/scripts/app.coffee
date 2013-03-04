define [
  'jquery',
  'underscore',
  'backbone',
  'router',
  'world_server'
], ($, _, Backbone, Router, WorldServer) ->
  'use strict'

  class TwoSnakes
    constructor: ->
      @server = new WorldServer
      @router = new Router(@server)
