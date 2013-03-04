require.config {
  paths: {
    json2: '../components/json2/json2'
    jquery: '../components/jquery/jquery',
    underscore: '../components/lodash/dist/lodash.underscore',
    backbone: '../components/backbone/backbone',
    bootstrap: 'vendor/bootstrap',
    jquery_websocket: 'vendor/jquery.websocket'
  },
  shim: {
    bootstrap: {
      deps: ['jquery'],
      exports: 'jquery'
    },
    jquery_websocket: {
      deps: ['jquery', 'json2'],
      exports: 'jquery'
    },
    underscore: {
      exports: '_'
    }
    backbone: {
      deps: ['underscore', 'jquery'],
      exports: 'Backbone'
    }
  }
}

require ['app'], (TwoSnakes) ->
  'use strict'
  app = new TwoSnakes
