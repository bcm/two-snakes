define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  'use strict'

  class Collection extends Backbone.Collection
    fetch: (options = {}) =>
      if options.session?
        options = this._addAuthorizationHeader(options.session, options)
      super(options)

    _addAuthorizationHeader: (session, options) =>
      options.headers = {
        'Authorization': "Token token=\"#{session.get('id')}\""
      }
      options
