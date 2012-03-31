# Comment in coffeescript
$(document).ready -> 
  # $(".tabs").button()
  # $(".change_date").click ->
  #   $.get "sightings", $.param(filter_time: $(this).attr("data-duration"))
  $(".autocomplete").bind 'railsAutocomplete.select', (event, data) ->
    console.log "Item selected"
    $("#sighting_search").submit()
  
  $("input:text:visible:first").focus()
  
  $("#search").catcomplete
    delay: 0
    source: "/home/auto_search.json"
    select: (event, ui) ->
      $("#" + ui.item.category).append "<li>" + ui.item.label + "</li"
      $("#" + ui.item.category + "_id").val(ui.item.value)
    close: (event, ui) ->
      @value = ""

  $("#tabs").tabs ajaxOptions:
    error: (xhr, status, index, anchor) ->
      $(anchor.hash).html "Couldn't load this tab. We'll try to fix this as soon as possible."
    
  $('#headlines').isotope
    itemSelector : '.headline'
    # layoutMode : 'masonry'
    masonry: {
        columnWidth: 20
      }


$.widget "custom.catcomplete", $.ui.autocomplete,
  _renderMenu: (ul, items) ->
    self = this
    currentCategory = ""
    $.each items, (index, item) ->
      unless item.category is currentCategory
        ul.append "<li class='ui-autocomplete-category'>" + capitaliseFirstLetter(item.category) + "</li>"
        currentCategory = item.category
      self._renderItem ul, item