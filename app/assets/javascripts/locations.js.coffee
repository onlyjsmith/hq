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
  newPoly = new google.maps.Polygon(
    paths: poly
    strokeColor: "#AA2143"
    strokeOpacity: 1
    strokeWeight: 2
    fillColor: "#FF6600"
    fillOpacity: 0.7
  )
  newPoly.cartodb_id = id
  newPoly.setMap carto_map
  google.maps.event.addListener newPoly, "click", ->
    @setEditable true
    setSelection this

  polys.push newPoly

getPolys = ->
  url = "http://craigmills.cartodb.com/api/v1/sql?q=SELECT cartodb_id,ST_AsGeoJSON(the_geom) as geoj FROM locations ORDER BY updated_at DESC LIMIT 25"
  $.getJSON url, (response) ->
    for i of response.rows
      coords = JSON.parse(response.rows[i].geoj).coordinates[0][0]
      poly = new Array()
      for j of coords
        poly.push new google.maps.LatLng(coords[j][1], coords[j][0])
      poly.pop()
      drawPolygon response.rows[i].cartodb_id, poly

clearSelection = ->
  if selectedShape
    storePoly selectedShape.getPath(), selectedShape.cartodb_id
    selectedShape.setEditable false
    selectedShape = null

setSelection = (shape) ->
  clearSelection()
  selectedShape = shape
  shape.setEditable true

storePoly = (path, cartodb_id) ->
  coords = new Array()
  payload =
    type: "MultiPolygon"
    coordinates: new Array()

  payload.coordinates.push new Array()
  payload.coordinates[0].push new Array()
  i = 0

  while i < path.length
    coord = path.getAt(i)
    coords.push coord.lng() + " " + coord.lat()
    payload.coordinates[0][0].push [ coord.lng(), coord.lat() ]
    i++
  q = "geojson=" + JSON.stringify(payload)
  q = q + "&cartodb_id=" + cartodb_id  if cartodb_id
  $.ajax
    url: "/locations/post_polygon.json"
    # crossDomain: true
    type: "POST"
    dataType: "json"
    data: q
    success: (responsedata) ->
      # console.log responsedata.cartodb_id
      $("#location_cartodb_id").val responsedata.cartodb_id
      # $("#response").html("<p>Fine</p>")
      console.log 'POSTed successfully'
      
    error: ->
      console.log 'POST failed for some reason'


$ ->
  $("#geocode_this").keyup ->
    # console.log "keyed up KILL THIS"
    codeAddress()

  cartodbMapOptions =
    zoom: 5
    center: new google.maps.LatLng(lat, lng)
    disableDefaultUI: true
    mapTypeId: google.maps.MapTypeId.TERRAIN

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
    newShape = e.overlay
    newShape.type = e.type
    google.maps.event.addListener newShape, "click", ->
      setSelection this

    setSelection newShape
    storePoly newShape.getPath()
    newShape.setEditable false
  
  codeAddress = ->
    address = $("#geocode_this").val()
    geocoder = new google.maps.Geocoder()
    geocoder.geocode
      address: address, (results, status) ->
        console.log results[0]
        carto_map.fitBounds results[0].geometry.bounds
    

  google.maps.event.addListener carto_map, "click", clearSelection