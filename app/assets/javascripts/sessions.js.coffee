# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  pollAuthStatus 60

pollAuthStatus = (num_retries_left) ->
  if num_retries_left == 0
    console.log("This seems to be taking to long. Try again later")
    window.location = "/"

  $.get "/sessions/status", (data) ->
    if data.status == "confirmed"
      window.location = "/"
    else if data.status == "errored"
      console.log(data.error)
      window.location = "/"
    else
      setTimeout ->
        pollAuthStatus num_retries_left
        , 10000

