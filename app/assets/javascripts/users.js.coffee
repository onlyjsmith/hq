# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  timeline = new VMM.Timeline()
  # timeline.init("http://veritetimeline.appspot.com/latest/examples/kitchen-sink.json")
  timeline.init("/users/56/timeline.json")
