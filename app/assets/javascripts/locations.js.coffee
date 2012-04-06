transformToGeoJSON = (geometries, type) ->
  type = type.toLowerCase()
  str = "{\"type\":\"" + (if (type is "multipolygon") then "MultiPolygon" else "MultiLineString") + "\",\"coordinates\":["
  points = geometries.getArray()
  str += (if (type is "multipolygon") then "[[" else "[")
  _.each points, (point, i) ->
    str += "[" + point.lng() + "," + point.lat() + "],"

  str += (if (type is "multipolygon") then "[" + points[0].lng() + "," + points[0].lat() + "]," else "")
  str = str.substr(0, str.length - 1)  if points.length > 0
  str += (if (type is "multipolygon") then "]]," else "],")
  str = str.substr(0, str.length - 1)
  str += "]}"
  str
auth = undefined
carto_map = undefined
cartodb_imagemaptype = undefined
clearSelection = undefined
codeAddress = undefined
drawPolygon = undefined
getPolys = undefined
image = undefined
lat = undefined
lng = undefined
overlay = undefined
polys = undefined
selectedShape = undefined
setSelection = undefined
status = undefined
storePoly = undefined
$ ->
  carto_map = undefined
  cartodbMapOptions = undefined
  drawingManager = undefined
  $("#geocode_this").keyup ->
    codeAddress()

  cartodbMapOptions =
    zoom: 5
    center: new google.maps.LatLng(lat, lng)
    disableDefaultUI: true
    mapTypeId: google.maps.MapTypeId.TERRAIN

  if $("#location_map").length
    carto_map = new google.maps.Map(document.getElementById("location_map"), cartodbMapOptions)
    getPolys()
    drawingManager = new google.maps.drawing.DrawingManager(
      drawingControl: true
      drawingControlOptions:
        position: google.maps.ControlPosition.TOP_RIGHT
        drawingModes: [ google.maps.drawing.OverlayType.POLYGON ]

      polygonOptions:
        fillColor: "#0099FF"
        fillOpacity: 0.7
        strokeColor: "#AA2143"
        strokeWeight: 2
        clickable: true
        zIndex: 1
        editable: true
    )
    drawingManager.setMap carto_map
    google.maps.event.addListener drawingManager, "overlaycomplete", (e) ->
      newShape = undefined
      newShape = e.overlay
      newShape.type = e.type
      google.maps.event.addListener newShape, "click", ->
        setSelection this

      setSelection newShape
      storePoly newShape.getPath()
      newShape.setEditable false

    google.maps.event.addListener carto_map, "click", clearSelection

overlay = undefined
cartodb_imagemaptype = undefined
image = undefined
selectedShape = undefined
polys = new Array()
auth = false
carto_map = null
status = "Ia"
lat = -15 + Math.floor(Math.random() * 5)
lng = 24 + Math.floor(Math.random() * 12)
drawPolygon = (id, poly) ->
  newPoly = undefined
  newPoly = new google.maps.Polygon(
    paths: poly
    strokeColor: "#333333"
    strokeOpacity: 1
    strokeWeight: 2
    fillColor: "#719700"
    fillOpacity: 0.7
  )
  newPoly.cartodb_id = id
  newPoly.setMap carto_map
  google.maps.event.addListener newPoly, "click", ->
    @setEditable true
    setSelection this

  polys.push newPoly

getPolys = ->
  url = undefined
  url = "http://craigmills.cartodb.com/api/v1/sql?q=SELECT cartodb_id,ST_AsGeoJSON(the_geom) as geoj FROM locations ORDER BY cartodb_id DESC LIMIT 25"
  $.getJSON url, (response) ->
    coords = undefined
    i = undefined
    j = undefined
    poly = undefined
    _results = undefined
    _results = []
    for i of response.rows
      coords = JSON.parse(response.rows[i].geoj).coordinates[0][0]
      poly = new Array()
      for j of coords
        poly.push new google.maps.LatLng(coords[j][1], coords[j][0])
      poly.pop()
      _results.push drawPolygon(response.rows[i].cartodb_id, poly)
    _results

clearSelection = ->
  if selectedShape
    storePoly selectedShape.getPath(), selectedShape.cartodb_id
    selectedShape.setEditable false
    selectedShape = null

setSelection = (shape) ->
  clearSelection()
  selectedShape = shape
  shape.setEditable true

storePoly = (path) ->
  $("#location_polygon").val transformToGeoJSON(path, "multipolygon")

codeAddress = ->
  address = undefined
  geocoder = undefined
  address = $("#geocode_this").val()
  geocoder = new google.maps.Geocoder()
  geocoder.geocode
    address: address
  , (results, status) ->
    console.log results[0]
    carto_map.fitBounds results[0].geometry.bounds