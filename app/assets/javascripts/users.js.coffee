# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# $ ->
#   timeline = new VMM.Timeline()
#   # timeline.init("http://veritetimeline.appspot.com/latest/examples/kitchen-sink.json")
# 
#   timeline_config = 
#     width: 900
#     height: 700
#     # // maptype: "watercolor", // OPTIONAL
#     # // css: 'path_to_file/timeline.css', // OPTIONAL
#     # // js: 'path_to_file/timeline.js', // OPTIONAL
#     source: "/users/56/timeline.json"
# 
#   
#   timeline_embed.init("/users/56/timeline.json")

# NEW page  
$(document).ready -> 
  if $("#user_sightings_map").length
    initializeUserSightingsMap()


# TODO: FOLLOWING COPIED FORM sightings.js.coffee - need to unify this code to avoid duplication

# INDEX page: map for sightings_index map tab
initializeUserSightingsMap = () -> 
  mapOptions =
    # Defaulting to location of first camp for now
    center: new google.maps.LatLng(-15.9, 28.0)
    # disableDefaultUI: true
    zoom: 13
    # zoom: 11
    mapTypeId: google.maps.MapTypeId.TERRAIN
    noClear: true

  # Create new map, add locations overlay, and export to global variable
  m = new google.maps.Map document.getElementById("user_sightings_map"), mapOptions

  # url = "http://a.tiles.mapbox.com/v3/onlyjsmith.wildspot-map.jsonp"
  # wax.tilejson url, (tilejson) ->
  #   m = new google.maps.Map(document.getElementById("sightings_map"),
  #     center: new google.maps.LatLng(-15.9, 28.0)
  #     disableDefaultUI: true
  #     zoom: 5
  #     # mapTypeId: google.maps.MapTypeId.ROADMAP
  #   )
  #   m.mapTypes.set "mb", new wax.g.connector(tilejson)
  #   m.setMapTypeId "mb"
  #   # wax.g.interaction().map(m).tilejson(tilejson).on wax.tooltip().parent(map.getDiv()).events()

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

