$(document).ready -> 
  $("#species").autocomplete
    minLength: 2
    source: "/species.json"
    select: ( event, ui ) ->
      values = []
      if ($("#species_ids}").val() != "")
        values = $("#species_ids").val().split(",")
      values.push (ui.item.value)
      console.log "Pushed " + ui.item.value + "   Array = " + values
      joined = values.join()
      $("#species_ids").val(joined)
      $("#results").append "<li>" + ui.item.label + "</li"
    close: (event, ui) ->
      @value = ""

  $("#tribes").autocomplete
    minLength: 2
    source: "/tribes.json"
    select: ( event, ui ) ->
      values = []
      if ($("#tribe_ids}").val() != "")
        values = $("#tribe_ids").val().split(",")
      values.push (ui.item.value)
      console.log "Pushed " + ui.item.value + "   Array = " + values
      joined = values.join()
      $("#tribe_ids").val(joined)
      $("#results").append "<li>" + ui.item.label + "</li"
    close: (event, ui) ->
      @value = ""

  $("#camps").autocomplete
    minLength: 2
    source: "/camps.json"
    select: ( event, ui ) ->
      values = []
      if ($("#camp_ids}").val() != "")
        values = $("#camp_ids").val().split(",")
      values.push (ui.item.value)
      console.log "Pushed " + ui.item.value + "   Array = " + values
      joined = values.join()
      $("#camp_ids").val(joined)
      $("#results").append "<li>" + ui.item.label + "</li"
    close: (event, ui) ->
      @value = ""

  $("#locations").autocomplete
    minLength: 2
    source: "/locations.json"
    select: ( event, ui ) ->
      values = []
      if ($("#location_ids}").val() != "")
        values = $("#location_ids").val().split(",")
      values.push (ui.item.value)
      console.log "Pushed " + ui.item.value + "   Array = " + values
      joined = values.join()
      $("#location_ids").val(joined)
      $("#results").append "<li>" + ui.item.label + "</li"
    close: (event, ui) ->
      @value = ""

