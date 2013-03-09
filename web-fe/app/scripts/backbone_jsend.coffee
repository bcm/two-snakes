define [
  'backbone',
], (Backbone) ->
  'use strict'

  Backbone.origSync = Backbone.sync
  Backbone.sync = (method, model, options = {}) =>
    options.success = (model, jsend, options) =>
      if jsend.status is 'success'
        model.trigger 'sync:success', jsend.data
      else if jsend.status is 'fail'
        model.trigger 'sync:failure', jsend.data
      else if jsend.status is 'error'
        model.trigger 'sync:error', jsend.code, jsend.message
    options.error = (model, xhr, options) =>
      console.log "ajax error: #{xhr.responseText}"
      model.trigger 'ajax:error', xhr
    Backbone.origSync(method, model, options)
