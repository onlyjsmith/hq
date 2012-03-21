# initialize = ->
#   myOptions =
#     center: new google.maps.LatLng(-12.6, 26)
#     zoom: 5
#     mapTypeId: google.maps.MapTypeId.TERRAIN
# 
#   map = new google.maps.Map(document.getElementById("map_canvas"), myOptions)
#   bounds = new google.maps.LatLngBounds(new google.maps.LatLng(-12.6, 26), new google.maps.LatLng(-16.82, 28.8))
#   rectangle = new google.maps.Rectangle(
#     bounds: bounds
#     editable: true
#   )
#   rectangle.setMap map
# google.maps.event.addDomListener window, "load", initialize
# 
# window.WILDSPOT = 
#   test: null
# 
# jQuery ->
#   $("[href^=#]").click (e) ->
#     e.preventDefault()
# 
#   window.WILDSPOT.initializeGoogleMaps()
#   $("#draw_poly").click ->
#     console.log 'yup'
#     window.WILDSPOT.mapPolygon = new google.maps.Polygon(_.extend(window.WILDSPOT.mapPolygonOptions,
#       strokeColor: "#08c"
#       fillColor: "#08c"
#     ))
#     window.WILDSPOT.mapPolygon.setMap window.WILDSPOT.map
#     window.WILDSPOT.currentAction = 0
# 
# window.WILDSPOT.initializeGoogleMaps = ->
#   window.WILDSPOT.map = new google.maps.Map(document.getElementById("map_canvas"), window.WILDSPOT.mapOptions)
#   google.maps.event.addListener window.WILDSPOT.map, "zoom_changed", ->
#     if window.WILDSPOT.map.getZoom() >= window.WILDSPOT.minEditZoom and window.WILDSPOT.selectedLayer >= 0
#       $("#main_menu .zoom").addClass "hide"
#       $("#main_menu .select-layer").addClass "hide"
#       $("#main_menu .actions").removeClass "hide"
#       window.WILDSPOT.mapPolygon.setEditable true  if window.WILDSPOT.mapPolygon
#     else if window.WILDSPOT.map.getZoom() >= window.WILDSPOT.minEditZoom
#       $("#main_menu .zoom").addClass "hide"
#       $("#main_menu .select-layer").removeClass "hide"
#       $("#main_menu .actions").addClass "hide"
#       window.WILDSPOT.mapPolygon.setEditable false  if window.WILDSPOT.mapPolygon
#     else
#       $("#main_menu .zoom").removeClass "hide"
#       $("#main_menu .select-layer").addClass "hide"
#       $("#main_menu .actions").addClass "hide"
#       window.WILDSPOT.mapPolygon.setEditable false  if window.WILDSPOT.mapPolygon
# 
#   window.WILDSPOT.mangroves_params =
#     map_canvas: "map_canvas"
#     map: window.WILDSPOT.map
#     user_name: "carbon-tool"
#     table_name: window.CARTODB_TABLE
#     query: "SELECT the_geom_webmercator FROM " + window.CARTODB_TABLE + " WHERE name=0 AND status=0"
#     tile_style: "#" + window.CARTODB_TABLE + "{polygon-fill:#B15F00;polygon-opacity:0.7;line-width:0}"