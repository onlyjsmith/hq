initialize = ->
  myOptions =
    center: new google.maps.LatLng(-12.6, 26)
    zoom: 5
    mapTypeId: google.maps.MapTypeId.TERRAIN

  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions)
  bounds = new google.maps.LatLngBounds(new google.maps.LatLng(-12.6, 26), new google.maps.LatLng(-16.82, 28.8))
  rectangle = new google.maps.Rectangle(
    bounds: bounds
    editable: true
  )
  rectangle.setMap map
google.maps.event.addDomListener window, "load", initialize
jQuery ->
  $("[href^=#]").click (e) ->
    e.preventDefault()

  window.VALIDATION.initializeGoogleMaps()
  $("#draw_poly").click ->
    console.log "yup"
    window.VALIDATION.mapPolygon = new google.maps.Polygon(_.extend(window.VALIDATION.mapPolygonOptions,
      strokeColor: "#08c"
      fillColor: "#08c"
    ))
    window.VALIDATION.mapPolygon.setMap window.VALIDATION.map
    window.VALIDATION.currentAction = 0

window.VALIDATION.initializeGoogleMaps = ->
  window.VALIDATION.map = new google.maps.Map(document.getElementById("map_canvas"), window.VALIDATION.mapOptions)
  google.maps.event.addListener window.VALIDATION.map, "zoom_changed", ->
    if window.VALIDATION.map.getZoom() >= window.VALIDATION.minEditZoom and window.VALIDATION.selectedLayer >= 0
      $("#main_menu .zoom").addClass "hide"
      $("#main_menu .select-layer").addClass "hide"
      $("#main_menu .actions").removeClass "hide"
      window.VALIDATION.mapPolygon.setEditable true  if window.VALIDATION.mapPolygon
    else if window.VALIDATION.map.getZoom() >= window.VALIDATION.minEditZoom
      $("#main_menu .zoom").addClass "hide"
      $("#main_menu .select-layer").removeClass "hide"
      $("#main_menu .actions").addClass "hide"
      window.VALIDATION.mapPolygon.setEditable false  if window.VALIDATION.mapPolygon
    else
      $("#main_menu .zoom").removeClass "hide"
      $("#main_menu .select-layer").addClass "hide"
      $("#main_menu .actions").addClass "hide"
      window.VALIDATION.mapPolygon.setEditable false  if window.VALIDATION.mapPolygon

  window.VALIDATION.mangroves_params =
    map_canvas: "map_canvas"
    map: window.VALIDATION.map
    user_name: "carbon-tool"
    table_name: window.CARTODB_TABLE
    query: "SELECT the_geom_webmercator FROM " + window.CARTODB_TABLE + " WHERE name=0 AND status=0"
    tile_style: "#" + window.CARTODB_TABLE + "{polygon-fill:#B15F00;polygon-opacity:0.7;line-width:0}"