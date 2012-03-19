# Comment in coffeescript
$(document).ready -> 
  $(".tabs").button()
  $(".change_date").click ->
    $.get "sightings", $.param(search: $(this).attr("data-duration"))

  $("input:text:visible:first").focus()
  $("#search").catcomplete
    delay: 0
    source: "/home/auto_search.json"
    select: (event, ui) ->
      $("#" + ui.item.category).append "<li>" + ui.item.value + "</li"

    close: (event, ui) ->
      @value = ""

$.widget "custom.catcomplete", $.ui.autocomplete,
  _renderMenu: (ul, items) ->
    self = this
    currentCategory = ""
    $.each items, (index, item) ->
      unless item.category is currentCategory
        ul.append "<li class='ui-autocomplete-category'>" + item.category + "</li>"
        currentCategory = item.category
      self._renderItem ul, item