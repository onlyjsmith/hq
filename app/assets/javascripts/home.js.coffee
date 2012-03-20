$(document).ready ->
  initialize_map()

initialize_map = ->
  wax.tilejson "http://a.tiles.mapbox.com/v3/onlyjsmith.wildspot-map.jsonp", (tilejson) ->
    sitesURL = "http://craigmills.cartodb.com/tiles/sites/{z}/{x}/{y}.png"
    sites = new L.TileLayer(sitesURL)
    @map = new L.Map("map-landing-page")
    @map.addLayer(new wax.leaf.connector(tilejson))
    @map.addLayer(sites)
    @map.setView(new L.LatLng(-12.6, 26), 5)  

    cartodb_leaflet = new L.CartoDBLayer(
      map_canvas: "map-landing-page"
      map: @map
      user_name: "craigmills"
      table_name: "sites"
      query: "SELECT cartodb_id,the_geom_webmercator,name FROM {{table_name}}"
      tile_style: "#{{table_name}}{marker-fill:#E25B5B}"
      infowindow: "SELECT cartodb_id,the_geom_webmercator,name FROM {{table_name}} WHERE cartodb_id={{feature}}"
      auto_bound: false
      debug: false
    )