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
  $.get "/sightings/new.json", (data) ->
    m = new google.maps.Map document.getElementById("new_map"),
      center: new google.maps.LatLng(data[1], data[0])
      disableDefaultUI: true
      zoom: 13
      mapTypeId: google.maps.MapTypeId.ROADMAP
    # m = window.NewMap  
    google.maps.event.addListener m, "click", (event) ->
      console.log "Clicked at lat:" + event.latLng.lat() + ", lng:" + event.latLng.lng()
      click = [event.latLng.lat(), event.latLng.lng()]

      all_loc_id =
        $.getJSON "http://craigmills.cartodb.com/api/v2/sql"+ 
        "?q=SELECT loc_id FROM locations WHERE ST_Intersects(ST_PointFromText('POINT("+ click[1] + " " + click[0] + " )', 4326), the_geom)"        

      console.log "Got loc_id from cartodb :" + loc_id
      
      console.log 'responding to click by refreshing locations tiles'


      locationOptions =
        getTileUrl: (coord, zoom) ->
          base_url = "http://craigmills.cartodb.com/tiles/locations/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
          base_style = "?style=%23locations {line-color:%23333333;line-width:2;line-opacity:0.48;polygon-opacity:0.48;polygon-fill:%23FFFFB2}%23locations [loc_id="
          loc_style = loc_id + "] {polygon-fill:%23B10026}"
          url = base_url + base_style + loc_style
          url
        tileSize: new google.maps.Size(256, 256)
      locationMapType = new google.maps.ImageMapType(locationOptions)
      m.overlayMapTypes.insertAt 1, locationMapType

      

    # # Add initial locations tiles overlay
    # locationOptions =
    #   getTileUrl: (coord, zoom, loc_id) ->
    #     console.log 'adding initial locations tiles - shouldnt be coloured'
    #     "http://craigmills.cartodb.com/tiles/locations/" + zoom + "/" + coord.x + "/" + coord.y + ".png"#"?style"+
    #     # "=#locations {line-color:#333333; line-width:2; line-opacity:0.48; polygon-opacity:0.9;} #locations[loc_id=" + loc_id + "]{polygon-fill:#F1EEF6}"
    #   tileSize: new google.maps.Size(256, 256)
    # locationMapType = new google.maps.ImageMapType(locationOptions)
    # m.overlayMapTypes.insertAt 1, locationMapType

    # Add sites tiles overlay
    siteOptions =
      getTileUrl: (coord, zoom) ->
        "http://craigmills.cartodb.com/tiles/sites/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
      tileSize: new google.maps.Size(256, 256)
    siteMapType = new google.maps.ImageMapType(siteOptions)
    m.overlayMapTypes.insertAt 2, siteMapType

    # Add changed bounds listener to repopulate search drop-down 
    google.maps.event.addListener m, "bounds_changed", (event) ->
      bounds = m.getBounds()
      bb = [bounds.getSouthWest().lat(), bounds.getSouthWest().lng(), bounds.getNorthEast().lat(), bounds.getNorthEast().lng()]
      $.get "/locations/search_by_bounding_box",
        bounding_box: bb,
        (response_data) ->

          $("#locations_search").autocomplete
            source: response_data
            select: (event, ui) ->
              $("#location_id").val(ui.item.value)
              $("#locations_search").val(ui.item.label)
  