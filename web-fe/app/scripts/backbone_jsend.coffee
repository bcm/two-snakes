define [
  'backbone',
], (Backbone) ->
  'use strict'

  Backbone.origSync = Backbone.sync
  Backbone.sync = (method, model, options = {}) =>
    options.success = (model, jsend, options) =>
      if jsend.status is 'success'
        model.trigger 'syncSuccess', jsend.data
      else if jsend.status is 'fail'
        model.trigger 'syncFailure', jsend.data
      else if jsend.status is 'error'
        model.trigger 'syncError', jsend.code, jsend.message
    options.error = (model, xhr, options) =>
      console.log "ajax error: #{xhr.responseText}"
      model.trigger 'ajaxError', xhr
    Backbone.origSync(method, model, options)
