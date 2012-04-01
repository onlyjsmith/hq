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

  $("#tabs").tabs 
    # cookie: 
    #   expires: 1
    ajaxOptions:
      error: (xhr, status, index, anchor) ->
        $(anchor.hash).html "Couldn't load this tab. We'll try to fix this as soon as possible."
    
  $('#headlines').isotope
    itemSelector : '.headline'
    # layoutMode : 'masonry'
    masonry: { columnWidth: 20 }

  $("#sightings_map").ready ->
    console.log 'sightings_map DIV loaded'
    initializeSightingsMap()
    
  $('#sightings_map').bind 'tabsshow', (event, ui) ->
    console.log "resizing map"
    resizeMap() if ui.panel.id is "map"
      
  
# MOVED TO global.js
# $.widget "custom.catcomplete", $.ui.autocomplete,
#   _renderMenu: (ul, items) ->
#     self = this
#     currentCategory = ""
#     $.each items, (index, item) ->
#       unless item.category is currentCategory
#         ul.append "<li class='ui-autocomplete-category'>" + capitaliseFirstLetter(item.category) + "</li>"
#         currentCategory = item.category
#       self._renderItem ul, item
      
initializeSightingsMap = () -> 
  url = "http://a.tiles.mapbox.com/v3/onlyjsmith.wildspot-map.jsonp"
  wax.tilejson url, (tilejson) ->
    m = new google.maps.Map(document.getElementById("sightings_map"),
      center: new google.maps.LatLng(-15.9, 28.0)
      disableDefaultUI: true
      zoom: 5
      # mapTypeId: google.maps.MapTypeId.ROADMAP
    )
    m.mapTypes.set "mb", new wax.g.connector(tilejson)
    m.setMapTypeId "mb"
    # wax.g.interaction().map(m).tilejson(tilejson).on wax.tooltip().parent(map.getDiv()).events()

    google.maps.event.addListener m, "click", (event) ->
      console.log "Clicked at lat:" + event.latLng.lat() + ", lng:" + event.latLng.lng()

    locationOptions =
      getTileUrl: (coord, zoom) ->
        "http://craigmills.cartodb.com/tiles/locations/" + zoom + "/" + coord.x + "/" + coord.y + ".png"

      tileSize: new google.maps.Size(256, 256)

    locationMapType = new google.maps.ImageMapType(locationOptions)
    m.overlayMapTypes.insertAt 0, locationMapType
