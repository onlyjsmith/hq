# Comment in coffeescript
$(document).ready -> 
  # $(".tabs").button()
  # $(".change_date").click ->
  #   $.get "sightings", $.param(filter_time: $(this).attr("data-duration"))
  $(".autocomplete.filters").bind 'railsAutocomplete.select', (event, data) ->
    console.log "Filter item selected"
    $("#sighting_search").submit()

  $(".autocomplete.new_sighting").bind 'railsAutocomplete.select', (event, data) ->
    console.log "New location item selected:" + data.item.id
    # Get map tiles from CartoDB                          
  
  $("a#reset_location").bind 'click', (event) -> 
    # console.log "clicked reset for " +  $(".autocomplete.new_sighting#q_location_name_cont")
    $(".autocomplete.new_sighting#q_location_name_cont")[0].value = ""
  
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

  # Looks for element on page, checks if exists using .length
  if $("#sightings_map").length
    initializeSightingsMap()

  if $("#new_map").length
    initializeNewMap()
    
  $('#tabs').bind 'tabsshow', (event, ui) ->
    $('#headlines').isotope('reLayout') if ui.panel.id is "headlines_panel"


# Map for sightings_index map tab
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

    siteOptions =
      getTileUrl: (coord, zoom) ->
        "http://craigmills.cartodb.com/tiles/sites/" + zoom + "/" + coord.x + "/" + coord.y + ".png"

      tileSize: new google.maps.Size(256, 256)

    siteMapType = new google.maps.ImageMapType(siteOptions)
    m.overlayMapTypes.insertAt 2, siteMapType
    


    $("#tabs").bind 'tabsshow', (event, ui) -> 
      if ui.panel.id is "map_panel" 
        google.maps.event.trigger(m, 'resize')
        centre = new google.maps.LatLng(-15.9, 28.0)
        m.setCenter centre 

# Map for new_sighting page
initializeNewMap = () -> 
  # url = "http://a.tiles.mapbox.com/v3/onlyjsmith.wildspot-map.jsonp"
  # wax.tilejson url, (tilejson) ->
  $.get "/sightings/new.json", (data) ->
    m = new google.maps.Map(document.getElementById("new_map"),
      center: new google.maps.LatLng(data[1], data[0])
      disableDefaultUI: true
      zoom: 13
      mapTypeId: google.maps.MapTypeId.ROADMAP
    )
    # m.mapTypes.set "mb", new wax.g.connector(tilejson)
    # m.setMapTypeId "mb"
    # wax.g.interaction().map(m).tilejson(tilejson).on wax.tooltip().parent(map.getDiv()).events()

    google.maps.event.addListener m, "click", (event) ->
      console.log "Clicked at lat:" + event.latLng.lat() + ", lng:" + event.latLng.lng()

    locationOptions =
      getTileUrl: (coord, zoom) ->
        "http://craigmills.cartodb.com/tiles/locations/" + zoom + "/" + coord.x + "/" + coord.y + ".png"

      tileSize: new google.maps.Size(256, 256)

    locationMapType = new google.maps.ImageMapType(locationOptions)
    m.overlayMapTypes.insertAt 0, locationMapType

    siteOptions =
      getTileUrl: (coord, zoom) ->
        "http://craigmills.cartodb.com/tiles/sites/" + zoom + "/" + coord.x + "/" + coord.y + ".png"

      tileSize: new google.maps.Size(256, 256)

    siteMapType = new google.maps.ImageMapType(siteOptions)
    m.overlayMapTypes.insertAt 2, siteMapType


getLocationsByBoundingBox = (topleft, bottomright) ->
  