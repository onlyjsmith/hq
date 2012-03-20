$(document).ready ->
  initialize_map()

initialize_map = ->
  wax.tilejson "http://a.tiles.mapbox.com/v3/onlyjsmith.wildspot-map.jsonp", (tilejson) ->
    sitesURL = "http://craigmills.cartodb.com/tiles/sites/{z}/{x}/{y}.png"
    sites = new L.TileLayer(sitesURL)
    map = new L.Map("map-landing-page").addLayer(new wax.leaf.connector(tilejson)).addLayer(sites).setView(new L.LatLng(-12.6, 26), 5)
