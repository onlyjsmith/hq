$(document).ready -> 
  $("input:text:visible:first").focus()
  $("#home_search").catcomplete
    delay: 0
    source: "/home/auto_search.json"
    focus: (event, ui) ->
      console.log "focus on " + ui.item.category + "#" + ui.item.id + " (" + ui.item.label + ")"
      # $("#home_search").val(ui.item.label)
    select: (event, ui) ->
      # $("#" + ui.item.category).append "<li>" + ui.item.label + "</li"
      # $("#" + ui.item.category + "_id").val(ui.item.value) 

      # FIXME: This only works for camps and locations
      window.location = "/" + ui.item.category + "s" + "/" + ui.item.id
    close: (event, ui) ->
      @value = "" 

  initializeLandingMap()

# TODO: Add interaction
initializeLandingMap = () -> 
  url = "http://a.tiles.mapbox.com/v3/onlyjsmith.wildspot-map.jsonp"
  wax.tilejson url, (tilejson) ->
    m = new google.maps.Map(document.getElementById("map-landing-page"),
      center: new google.maps.LatLng(-15.5, 24.8)
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
