define [
  'jquery',
  'underscore',
  'backbone',
  'model',
  'player'
], ($, _, Backbone, Model, Player) ->
  'use strict'

  class Session extends Model
    @init: (playerAttrs) =>
      localStorage.setItem('twosnakes.session.player', JSON.stringify(playerAttrs))
      player = new Player(JSON.parse(playerAttrs))
      new Session(id: player.get('session_token'), player: player)

    @resume: =>
      playerAttrs = localStorage.getItem('twosnakes.session.player')
      player = new Player(JSON.parse(playerAttrs)) if playerAttrs?
      characterAttrs = localStorage.getItem('twosnakes.session.character')
      character = new Character(JSON.parse(characterAttrs)) if characterAttrs?
      if player?
        new Session(id: player.get('session_token'), player: player, character: character)

    url: => 'http://localhost:5000/session'

    save: (attributes = {}, options = {}) =>
      this.on 'sync:success', (data) =>
        # XXX: get player attributes from server
        playerAttrs = {email: this.get('email'), session_token: data.token}
        player = new Player(playerAttrs)
        this.set('id', player.get('session_token'))
        this.set('player', player)
        localStorage.setItem('twosnakes.session.player', JSON.stringify(playerAttrs))
        this.trigger("session:saved")
      super(attributes, options)

    destroy: (options = {}) =>
      options.session = this
      this.on 'sync:success', (data) =>
        localStorage.removeItem('twosnakes.session.player')
        this.trigger "session:destroyed"
      super(options)
