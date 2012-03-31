$(document).ready -> 
  $("input:text:visible:first").focus()
  $("#home_search").catcomplete
    delay: 0
    source: "/home/auto_search.json"
    select: (event, ui) ->
      console.log ui.item.category + " > " + ui.item.value
      # $("#" + ui.item.category).append "<li>" + ui.item.label + "</li"
      # $("#" + ui.item.category + "_id").val(ui.item.value)
      
    close: (event, ui) ->
      @value = ""
