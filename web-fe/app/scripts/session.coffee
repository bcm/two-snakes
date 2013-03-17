define [
  'jquery',
  'underscore',
  'backbone',
  'model'
], ($, _, Backbone, Model) ->
  'use strict'

  class Session extends Model
    url: => 'http://localhost:5000/session'

    parse: (response, options = {}) =>
      player = new Player(response)
      {id: player.get('session_token'), player: player, email: null, password: null}
