define [
  'backbone',
], (Backbone) ->
  'use strict'

  Backbone.origSync = Backbone.sync
  Backbone.sync = (method, model, options = {}) =>
    origSuccess = options.success
    origError = options.error
    options.success = (model, jsend, options) =>
      if jsend.status is 'success'
        model.trigger 'sync:success', jsend.data
        origSuccess(model, jsend.data, options) if origSuccess?
      else if jsend.status is 'fail'
        model.trigger 'sync:failure', jsend.data
      else if jsend.status is 'error'
        console.log "server error (#{jsend.code}): #{jsend.message}"
        model.trigger 'sync:error', jsend.code, jsend.message
    options.error = (model, xhr, options) =>
      console.log "ajax error: #{xhr.responseText}"
      model.trigger 'ajax:error', xhr
      origError(model, xhr, options) if origError?
    Backbone.origSync(method, model, options)
