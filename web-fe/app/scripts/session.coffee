define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  'use strict'

  class Session extends Backbone.Model
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
      options.headers = {
        'Authorization': "Token token=\"#{this.get('id')}\""
      }
      this.on 'sync:success', (data) =>
        localStorage.removeItem('twosnakes.session.token')
      super(options)
