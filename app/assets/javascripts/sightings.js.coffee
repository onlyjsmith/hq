$(document).ready -> 
  # ALL ACTIONS: place cursor in first input box
  $("input:text:visible:first").focus()
  
  # FILTERS partial
  $(".autocomplete.filters").bind 'railsAutocomplete.select', (event, data) ->
    console.log "Filter item selected"
    $("#sighting_search").submit()
  
  # $("a#reset_location").bind 'click', (event) -> 
  #   $(".autocomplete.new_sighting#q_location_name_cont")[0].value = ""
  
  # OLD-NEW page (OMNI-ENTER box)
  $("#search").catcomplete
    delay: 0
    source: "/home/auto_search.json"
    select: (event, ui) ->
      $("#" + ui.item.category).append "<li>" + ui.item.label + "</li"
      $("#" + ui.item.category + "_id").val(ui.item.value)
    close: (event, ui) ->
      @value = ""

  # INDEX page
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

  $('#tabs').bind 'tabsshow', (event, ui) ->
    $('#headlines').isotope('reLayout') if ui.panel.id is "headlines_panel"

  # NEW page  
  if $("#new_map").length
    initializeNewMap()
    
  $(".species_photos").click ->
    id = this.dataset.speciesId
    # console.log 'clicked ' + this.dataset.speciesId + ' photo. well done'
    $("#species_options").html("<li>Species_id = " + id + "</li>")
    
  
# INDEX page: map for sightings_index map tab
initializeSightingsMap = () -> 
  mapOptions =
    # Defaulting to location of first camp for now
    center: new google.maps.LatLng(-15.9, 28.0)
    # disableDefaultUI: true
    zoom: 13
    # zoom: 11
    mapTypeId: google.maps.MapTypeId.TERRAIN
    noClear: true

  # Create new map, add locations overlay, and export to global variable
  m = new google.maps.Map document.getElementById("sightings_map"), mapOptions

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

        
# NEW page: map for new_sighting page
initializeNewMap = () -> 

  # Add initial locations tiles overlay
  addLocationsOverlay = (map) ->
    locationOptions =
      getTileUrl: (coord, zoom) ->
        "http://craigmills.cartodb.com/tiles/locations/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
      tileSize: new google.maps.Size(256, 256)
    locationMapType = new google.maps.ImageMapType(locationOptions)
    map.overlayMapTypes.insertAt 0, locationMapType

  # Add sites tiles overlay
  addSitesOverlay = (map) ->
    siteOptions =
      getTileUrl: (coord, zoom) ->
        "http://craigmills.cartodb.com/tiles/sites/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
      tileSize: new google.maps.Size(256, 256)
    siteMapType = new google.maps.ImageMapType(siteOptions)
    m.overlayMapTypes.insertAt 1, siteMapType

  # Add LISTENERS
  addListeners = (map) ->
    
    # On click, searches for locations under click
    google.maps.event.addListener m, "click", (event) ->
      clickCoords = [event.latLng.lat(), event.latLng.lng()]
      console.log clickCoords
      searchFromClick(clickCoords)
    
    # Add IDLE listener to repopulate search drop-down - waits until zooming, panning finished
    google.maps.event.addListener m, "idle", (event) ->
      bounds = m.getBounds()
      bb = [bounds.getSouthWest().lat(), bounds.getSouthWest().lng(), bounds.getNorthEast().lat(), bounds.getNorthEast().lng()]
      searchFromBoundingBox(bb)

  # MAP FUNCTIONS

  searchFromClick = (clickCoords) ->
    $.get "/locations/search.json", {coords: clickCoords}, (responseData) ->
      responseText = ""
      $.each responseData, (i,v) ->
        responseText += "<li>Location_id = " + v + "</li>"
      $("#location_options").html(responseText)
      decideFromClick(responseData, clickCoords)

  decideFromClick = (responseData, coords) ->
    if responseData.length == 0
      window.NewMap.overlayMapTypes.removeAt 0
      addLocationsOverlay(window.NewMap)
      createFromPoint(coords)
    else
      id = responseData[0]
      loadAndSelectLocation(id)

  createFromPoint = (coords) ->
    $.post "/locations.json", {coords: coords}, (data) ->
      loadAndSelectLocation(data.id)
      map.overlayMapTypes.removeAt 0
      addLocationsOverlay()

  searchFromBoundingBox = (bb) ->
    $.get "/locations/search.json",
      bounding_box: bb,
      (responseData) ->
        populateSearch(responseData)
        populateLocationOptionsFromSearch(responseData)
    
  populateSearch = (responseData) ->
    $("#locations_search").autocomplete
      source: responseData
      select: (event, ui) ->
        $("#location_id").val(ui.item.value)
        # $("#locations_search").val(ui.item.label)
        $("#location_selection}").html("<li>Location_id = " + ui.item.value + "</li>")

  populateLocationOptionsFromSearch = (responseData) ->
    content = ""
    $.each responseData, (index, item) ->
      content += "<li><a href='#' data-location-id=" + item.value + " class='location_option'>" + item.label + " (#" + item.value + ")</a></li>"
    $("#location_options").html(content)
    $(".location_option").click ->
      $("#location_selection").html("<li>Location_id = " + this.dataset.locationId + "</li>")

  recenterMap = (clickCoords) ->
    map = window.NewMap
    center = new google.maps.LatLng(clickCoords[1], clickCoords[0])
    map.setCenter center
      
  clearLocationVectors = ->
    map = window.NewMap
    console.log "Clearing vectors"
    if window.SelectedVector?
      window.SelectedVector.setMap(null)

  loadAndSelectLocation = (id) ->
    clearLocationVectors()
    loadVector(id)
    $("#location_id").val(id)
    $("#location_selection}").html("<li>Location_id = " + id + "</li>")

  loadVector = (id) ->
    # Adding vector layer to highlight selected location
    map = window.NewMap
    location_vector = new gvector.CartoDB(
      user: "craigmills"
      table: "locations"
      where: "loc_id = " + id
      scaleRange: [ 3, 20 ]
      # infoWindowTemplate: "<div>Here</div>"
      infoWindowTemplate: null
      # infoWindowTemplate: "<div><a href='#' data-location-id=#{id} class='location_option_popup'>Location: ##{id}</a></div>"
      singleInfoWindow: true
      symbology: {
          type: "single", # Defines the symbology as a single type of representation for all features
          vectorOptions: { # Google maps vector options for all features
              fillColor: "#dca37d",
              fillOpacity: 0.8,
              strokeWeight: 3,
              strokeColor: "#d18655"
          }    
      }
    )
    window.SelectedVector = location_vector
    location_vector.setMap(map)
    console.log "Done vector layer loading. See any different?"
  
  
    
  # Set initial map options
  mapOptions =
    # Defaulting to location of first camp for now
    center: new google.maps.LatLng(-19.02071, 22.69788)
    # disableDefaultUI: true
    zoom: 13
    # zoom: 11
    mapTypeId: google.maps.MapTypeId.TERRAIN
    noClear: true

  # Create new map, add locations overlay, and export to global variable
  m = new google.maps.Map document.getElementById("new_map"), mapOptions
  addLocationsOverlay(m)
  addSitesOverlay(m)
  addListeners(m)
  populateSearch(m)
  populateLocationOptionsFromSearch(m)
  window.NewMap = m
