define ['jquery', 'jquery_websocket'], ($, ws) ->
  'use strict'

  jQuery ->
    ws = $.websocket('ws://127.0.0.1:8888/websocket/',
      open: ((e) ->
        $('#output').append('<li>Web Socket opened<li>')
      ),
      close: ((e) ->
        $('#output').append('<li>Web Socket closed</li>')
      ),
      events: {
        message: (e) ->
          $('#output').append("<li>#{e.data}</li>")
      }
    )

    $('input[name=message]').focus().on 'change', (e) ->
      ws.send('message', this.value)
      $(this).val('')
