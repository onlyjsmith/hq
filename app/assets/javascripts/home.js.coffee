$(document).ready ->
  initialize_map()

initialize_map = ->
  wax.tilejson "http://a.tiles.mapbox.com/v3/onlyjsmith.wildspot-map.jsonp", (tilejson) ->
    @map = new L.Map("map_landing_page")
    @map.addLayer(new wax.leaf.connector(tilejson))
    @map.setView(new L.LatLng(-12.6, 26), 5)  
  
    # sitesURL = "http://craigmills.cartodb.com/tiles/sites/{z}/{x}/{y}.png"
    # sites = new L.TileLayer(sitesURL)
    # @map.addLayer(sites)


    cartodb_leaflet = new L.CartoDBLayer(
      map_canvas: "map_landing_page"
      map: @map
      user_name: "craigmills"
      table_name: "sites"
      query: 'SELECT cartodb_id,the_geom_webmercator,name FROM {{table_name}}'
      tile_style: "#sites{marker-fill:#E25B5B}"
      infowindow: "SELECT cartodb_id,the_geom_webmercator,name FROM {{table_name}} WHERE cartodb_id={{feature}}"
      auto_bound: false
      debug: true
    )
