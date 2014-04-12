# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


show_ajax_message = (msgs, type) ->
  for msg in msgs.split('::')
    if (msg == 'clear')
      $('#game-messages').html('')
    else
      $('#game-messages').append("<li>" + msg + "</li>")

$(document).ajaxComplete ( event, request ) ->
  msg = request.getResponseHeader('X-Message')
  if (msg)
    show_ajax_message(msg, '')

