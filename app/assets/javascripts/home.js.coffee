$(document).ready -> 
  $("input:text:visible:first").focus()
  $("#home_search").catcomplete
    delay: 0
    source: "/home/auto_search.json"
    select: (event, ui) ->
      console.log ui.item.category + " > " + ui.item.value
      # $("#" + ui.item.category).append "<li>" + ui.item.label + "</li"
      # $("#" + ui.item.category + "_id").val(ui.item.value)
      
    close: (event, ui) ->
      @value = "" 

  initializeLandingMap()

initializeLandingMap = () -> 
  url = "http://a.tiles.mapbox.com/v3/onlyjsmith.geography-class.jsonp"
  console.log "loading map from" + url
  wax.tilejson url, (tilejson) ->
    m = new google.maps.Map(document.getElementById("map-landing-page"),
      center: new google.maps.LatLng(18.521283, 36.650391)
      disableDefaultUI: true
      zoom: 5
      # mapTypeId: google.maps.MapTypeId.ROADMAP
    )
    m.mapTypes.set "mb", new wax.g.connector(tilejson)
    m.setMapTypeId "mb"
    wax.g.interaction().map(m).tilejson(tilejson).on wax.tooltip().parent(map.getDiv()).events()
    