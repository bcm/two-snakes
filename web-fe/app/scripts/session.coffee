define [
  'jquery',
  'underscore',
  'backbone',
  'model',
  'player'
], ($, _, Backbone, Model, Player) ->
  'use strict'

  class Session extends Model
    url: => 'http://localhost:5000/session'

    parse: (response, options = {}) =>
      player = new Player(response)
      {id: player.get('sessionToken'), player: player, email: null, password: null}

    destroy: (options = {}) =>
      options.session = this
      super(options)
