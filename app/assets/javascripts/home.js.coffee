$(document).ready -> 
  $("#species").autocomplete
    minLength: 2
    source: "/species.json"
    select: ( event, ui ) ->
      $("#results").append "<li>" + ui.item.label + "</li"
      $("#species_id").val(ui.item.value)
    close: (event, ui) ->
      @value = ""

