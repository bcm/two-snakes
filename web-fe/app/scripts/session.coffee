define [
  'jquery',
  'underscore',
  'backbone',
  'model'
], ($, _, Backbone, Model) ->
  'use strict'

  # XXX: get player back from server and store it locally, instead of just token
  class Session extends Model
    @init: (token) =>
      localStorage.setItem('twosnakes.session.token', token)
      new Session(id: token)

    @resume: =>
      token = localStorage.getItem('twosnakes.session.token')
      new Session(id: token) if token?

    url: => 'http://localhost:5000/session'

    save: (attributes = {}, options = {}) =>
      this.on 'sync:success', (data) =>
        this.set('id', data.token)
        localStorage.setItem('twosnakes.session.token', data.token)
      super(attributes, options)

    destroy: (options = {}) =>
      options.session = this
      this.on 'sync:success', (data) =>
        localStorage.removeItem('twosnakes.session.token')
      super(options)
