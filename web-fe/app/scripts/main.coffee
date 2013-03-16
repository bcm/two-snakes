require.config {
  paths: {
    json2: '../components/json2/json2'
    jquery: '../components/jquery/jquery',
    underscore: '../components/lodash/dist/lodash.underscore',
    backbone: '../components/backbone/backbone',
    modernizr: '../components/modernizr/modernizr',
    bootstrap: 'vendor/bootstrap',
    jquery_websocket: 'vendor/jquery.websocket',
    text: '../components/requirejs-text/text'
  },
  shim: {
    bootstrap: {
      deps: ['jquery'],
      exports: 'jquery'
    },
    jquery_websocket: {
      deps: ['jquery', 'json2']
    },
    underscore: {
      exports: '_'
    }
    backbone: {
      deps: ['underscore', 'jquery'],
      exports: 'Backbone'
    },
    modernizr: {
      exports: 'Modernizr'
    }
  }
}

require ['app', 'modernizr'], (TwoSnakes, Modernizr) ->
  'use strict'

  if Modernizr.websockets and Modernizr.localstorage
    window.app = new TwoSnakes
  else
    alert("Your browser sucks!")
