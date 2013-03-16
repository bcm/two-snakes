define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  'use strict'

  class Model extends Backbone.Model
    save: (attributes = {}, options = {}) =>
      if options.session?
        options = this._addAuthorizationHeader(options.session, options)
      super(attributes, options)

    destroy: (options = {}) =>
      if options.session?
        options = this._addAuthorizationHeader(options.session, options)
      super(options)

    _addAuthorizationHeader: (session, options) =>
      options.headers = {
        'Authorization': "Token token=\"#{session.get('id')}\""
      }
      options
