define ['jquery'], ($) ->
  'use strict'

  unless window.WebSocket?
    window.WebSocket = window.MozWebSocket
  if window.WebSocket?
    socket = new WebSocket("ws://localhost:8888/websocket/")
    socket.onmessage = (event) ->
      ta = document.getElementById('responseText')
      ta.value = ta.value + "\n" + event.data
    socket.onopen = (event) ->
      ta = document.getElementById('responseText')
      ta.value = "Web Socket opened!"
    socket.onclose = (event) ->
      ta = document.getElementById('responseText')
      ta.value = ta.value + "\nWeb Socket closed"
  else
    alert("Your browser does not support Web Sockets.")

  send = (message) ->
    return unless window.WebSocket?
    if socket.readyState is WebSocket.OPEN
      socket.send(message)
    else
      alert "The socket is not open."

  jQuery ->
    $('input[type=button]').on 'click', (e) ->
      send(this.form.message.value)
      false

  true
