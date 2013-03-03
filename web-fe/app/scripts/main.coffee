require.config {
  paths: {
    json2: '../components/json2/json2'
    jquery: '../components/jquery/jquery',
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
  }
}

require ['app', 'jquery', 'bootstrap'], (app, $) ->
  'use strict'
