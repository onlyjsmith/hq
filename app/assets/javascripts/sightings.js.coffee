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
    
    
  # populateLocationSearch = (boundingbox) ->
  #   alert boundingbox
  #   $.get "/locations/search_by_bounding_box",
  #       bounding_box: bb,
  #       (response_data) ->
  # 
  #         $("#locations_search").autocomplete
  #           source: response_data
  #           select: (event, ui) ->
  #             $("#location_id").val(ui.item.value)
  #             $("#locations_search").val(ui.item.label)
  
  
# INDEX page: map for sightings_index map tab
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
        
# NEW page: map for new_sighting page
initializeNewMap = () -> 

  # Add initial locations tiles overlay
  addLocationsOverlay = (map) ->
    locationOptions =
      getTileUrl: (coord, zoom, loc_id) ->
        console.log 'adding initial locations tiles - shouldnt be coloured'
        "http://craigmills.cartodb.com/tiles/locations/" + zoom + "/" + coord.x + "/" + coord.y + ".png"#"?style"+
        # "=#locations {line-color:#333333; line-width:2; line-opacity:0.48; polygon-opacity:0.9;} #locations[loc_id=" + loc_id + "]{polygon-fill:#F1EEF6}"
      tileSize: new google.maps.Size(256, 256)
    locationMapType = new google.maps.ImageMapType(locationOptions)
    map.overlayMapTypes.insertAt 1, locationMapType

  # Add sites tiles overlay
  addSitesOverlay = (map) ->
    siteOptions =
      getTileUrl: (coord, zoom) ->
        "http://craigmills.cartodb.com/tiles/sites/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
      tileSize: new google.maps.Size(256, 256)
    siteMapType = new google.maps.ImageMapType(siteOptions)
    m.overlayMapTypes.insertAt 2, siteMapType

  # Add LISTENERS
  addListeners = (map) ->
    # On click, searches for locations under click
    google.maps.event.addListener m, "click", (event) ->
      clickCoords = [event.latLng.lat(), event.latLng.lng()]
      # console.log clickCoords
      $.get "/locations/find_by_coords.json", {coords: clickCoords}, (responseData) ->
        # console.log responseData
        responseText = ""
        $.each responseData, (i,v) ->
          responseText += "<li>Location_id = " + v + "</li>"
        $("#location_options").html(responseText)
        clearLocationVectors()
        loadLocationVectors(responseData)
    
    # Add IDLE listener to repopulate search drop-down - waits until zooming, panning finished
    google.maps.event.addListener m, "idle", (event) ->
      bounds = m.getBounds()
      bb = [bounds.getSouthWest().lat(), bounds.getSouthWest().lng(), bounds.getNorthEast().lat(), bounds.getNorthEast().lng()]
      $.get "/locations/search_by_bounding_box",
        bounding_box: bb,
        (responseData) ->
          populateSearch(responseData)

  # MAP FUNCTIONS
  recenterMap = (clickCoords) ->
    map = window.NewMap
    # console.log 'clickCoords = ' + clickCoords
    # center = new google.maps.LatLng(22.69788, -19.02071)
    center = new google.maps.LatLng(clickCoords[1], clickCoords[0])
    # console.log 'recentreing map to ' + center
    map.setCenter center
    
  populateSearch = (data) ->
    $("#locations_search").autocomplete
      source: response_data
      select: (event, ui) ->
        $("#location_id").val(ui.item.value)
        $("#locations_search").val(ui.item.label)

  clearLocationVectors = ->
    map = window.NewMap
    console.log "Clearing vectors"
    if window.Vector?
      window.Vector.setMap(null)

  loadLocationVectors = (ids) ->
    map = window.NewMap
    console.log "Loading vectors for: " + ids
    
    location_vector = new gvector.CartoDB(
      user: "craigmills"
      table: "locations"
      where: "loc_id = " + ids[0]
      scaleRange: [ 3, 20 ]
      infoWindowTemplate: "<div>Location {ids}</div>"
      # infoWindowTemplate: "<div class=\"iw-content\"><h3>Location</h3><table class=\"condensed-table\"><tr><th>Diameter</th><td>{mh_dia} ft.</td></tr><tr><th>Depth</th><td>{mh_depth} ft.</td></tr><tr><th>Address</th><td>{street_add}</td></tr><tr><th>Flows To</th><td>{wwtp} WWTP</td></tr></table></div>"
      singleInfoWindow: true
      symbology: {
          type: "single", # Defines the symbology as a single type of representation for all features
          vectorOptions: { # Google maps vector options for all features
              fillColor: "#46461f",
              fillOpacity: 0.5,
              strokeWeight: 4,
              strokeColor: "#ff7800"
          }    
      }
    )
    window.Vector = location_vector
    location_vector.setMap(map)
    console.log "Done loading. See any different?"
    
    # click = [event.latLng.lat(), event.latLng.lng()]
    # 
    # all_loc_id =
    #   $.getJSON "http://craigmills.cartodb.com/api/v2/sql"+ 
    #   "?q=SELECT loc_id FROM locations WHERE ST_Intersects(ST_PointFromText('POINT("+ click[1] + " " + click[0] + " )', 4326), the_geom)"        
    # 
    # console.log "Got loc_id from cartodb :" + loc_id
    # 
    # console.log 'responding to click by refreshing locations tiles'
  

    # locationOptions =
    #   getTileUrl: (coord, zoom) ->
    #     base_url = "http://craigmills.cartodb.com/tiles/locations/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
    #     base_style = "?style=%23locations {line-color:%23333333;line-width:2;line-opacity:0.48;polygon-opacity:0.48;polygon-fill:%23FFFFB2}%23locations [loc_id="
    #     loc_style = loc_id + "] {polygon-fill:%23B10026}"
    #     url = base_url + base_style + loc_style
    #     url
    #   tileSize: new google.maps.Size(256, 256)
    # locationMapType = new google.maps.ImageMapType(locationOptions)
    # m.overlayMapTypes.insertAt 1, locationMapType

    
  # Set initial map options
  mapOptions =
    # Defaulting to location of first camp for now
    center: new google.maps.LatLng(-19.02071, 22.69788)
    disableDefaultUI: true
    zoom: 13
    mapTypeId: google.maps.MapTypeId.ROADMAP
    noClear: true

  # Create new map, add locations overlay, and export to global variable
  m = new google.maps.Map document.getElementById("new_map"), mapOptions
  addLocationsOverlay(m)
  addSitesOverlay(m)
  addListeners(m)
  window.NewMap = m


