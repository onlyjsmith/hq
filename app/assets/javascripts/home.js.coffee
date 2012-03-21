# $(document).ready ->
#   initialize_landing_map()

initialize_landing_map = ->
  wax.tilejson "http://a.tiles.mapbox.com/v3/onlyjsmith.wildspot-map.jsonp", (tilejson) ->
    map = new google.maps.Map(document.getElementById("map_landing_page"),
      center: new google.maps.LatLng(-12.6, 26)
      disableDefaultUI: true
      zoom: 5
      mapTypeId: google.maps.MapTypeId.ROADMAP
    )
    map.mapTypes.set "mb", new wax.g.connector(tilejson)
    map.setMapTypeId "mb"

    cartodb_layer =
      getTileUrl: (coord, zoom) ->
        "http://craigmills.cartodb.com/tiles/sites/" + zoom + "/" + coord.x + "/" + coord.y + ".png"

      tileSize: new google.maps.Size(256, 256)

    cartodb_imagemaptype = new google.maps.ImageMapType(cartodb_layer)
    map.overlayMapTypes.insertAt 0, cartodb_imagemaptype
google.maps.event.addDomListener window, "load", initialize_landing_map  

  # Working basic map
  # 
  # initialize_map = ->
  #   wax.tilejson "http://a.tiles.mapbox.com/v3/onlyjsmith.wildspot-map.jsonp", (tilejson) ->
  #     m = new google.maps.Map(document.getElementById("map_landing_page"),
  #       center: new google.maps.LatLng(-12.6, 26)
  #       disableDefaultUI: true
  #       zoom: 5
  #       mapTypeId: google.maps.MapTypeId.ROADMAP
  #     )
  #     m.mapTypes.set "mb", new wax.g.connector(tilejson)
  #     m.setMapTypeId "mb"




  # Older LEAFLET implementation of map

  # initialize_map = ->
  #   wax.tilejson "http://a.tiles.mapbox.com/v3/onlyjsmith.wildspot-map.jsonp", (tilejson) ->
  #     @map = new L.Map("map_landing_page")
  #     @map.addLayer(new wax.leaf.connector(tilejson))
  #     @map.setView(new L.LatLng(-12.6, 26), 5)  
  #   
  #     # sitesURL = "http://craigmills.cartodb.com/tiles/sites/{z}/{x}/{y}.png"
  #     # sites = new L.TileLayer(sitesURL)
  #     # @map.addLayer(sites)
  # 
  # 
  #     cartodb_leaflet = new L.CartoDBLayer(
  #       map_canvas: "map_landing_page"
  #       map: @map
  #       user_name: "craigmills"
  #       table_name: "sites"
  #       query: 'SELECT cartodb_id,the_geom_webmercator,name FROM {{table_name}}'
  #       tile_style: "#sites{marker-fill:#E25B5B}"
  #       infowindow: "SELECT cartodb_id,the_geom_webmercator,name AS Name FROM {{table_name}} WHERE cartodb_id={{feature}}"
  #       auto_bound: false
  #       debug: true
  #     )
