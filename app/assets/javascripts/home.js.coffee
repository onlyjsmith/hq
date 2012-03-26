$(document).ready -> 
  $("#species").autocomplete
    minLength: 2
    source: "/species.json"
    select: ( event, ui ) ->
      log (if ui.item then "Selected: " + ui.item.value + " aka " + ui.item.id else "Nothing selected, input was " + @value)

  $("#tribe").autocomplete
    minLength: 2
    source: "/tribes.json"
    select: ( event, ui ) ->
      log (if ui.item then "Selected: " + ui.item.value + " aka " + ui.item.id else "Nothing selected, input was " + @value)

  $("#camp").autocomplete
    minLength: 2
    source: "/camps.json"
    select: ( event, ui ) ->
      log (if ui.item then "Selected: " + ui.item.value + " aka " + ui.item.id else "Nothing selected, input was " + @value)

  $("#location").autocomplete
    minLength: 2
    source: "/locations.json"
    select: ( event, ui ) ->
      log (if ui.item then "Selected: " + ui.item.value + " aka " + ui.item.id else "Nothing selected, input was " + @value)
