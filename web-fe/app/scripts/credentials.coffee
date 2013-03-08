define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  'use strict'

  class Credentials extends Backbone.Model
    url: => 'http://localhost:5000/session'

    save: (attributes, options) =>
      this.on 'syncSuccess', (data) =>
        this.trigger 'loginSuccess', data.token
      this.on 'syncError', (code, message) =>
        this.trigger 'loginFailed'
      super(attributes, options)
