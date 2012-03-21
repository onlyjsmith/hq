# initialize = ->
#   map = new google.maps.Map(document.getElementById("map_landing_page"),
#     center: new google.maps.LatLng(20, 0)
#     zoom: 4
#     mapTypeId: google.maps.MapTypeId.TERRAIN
#     mapTypeControl: false
#   )
#   cartodb2_gmapsv3 = new google.maps.CartoDBLayer(
#     map_canvas: 'map_landing_page'
#     map: map
#     user_name: "examples"
#     table_name: "earthquakes"
#     query: "SELECT cartodb_id,the_geom_webmercator,magnitude FROM {{table_name}}"
#     tile_style: "#{{table_name}}{marker-fill:#E25B5B}"
#     map_style: true
#     infowindow: "SELECT cartodb_id,the_geom_webmercator,magnitude FROM {{table_name}} WHERE cartodb_id={{feature}}"
#     auto_bound: false
#     debug: false
#   )
#   cartodb1_gmapsv3 = new google.maps.CartoDBLayer(
#     map_canvas: 'map_landing_page'
#     map: map
#     user_name: 'examples'
#     table_name: 'country_colors'
#     query: "SELECT * FROM {{table_name}}"
#     map_style: false
#     infowindow: false
#     auto_bound: false
#     debug: true
#   )
# cartodb1_gmapsv3 = undefined
# cartodb2_gmapsv3 = undefined
# cartodb3_gmapsv3 = undefined
# google.maps.event.addDomListener window, "load", initialize

$(document).ready ->
  initialize_landing_map()


initialize_landing_map = ->
  # wax.tilejson "http://a.tiles.mapbox.com/v3/onlyjsmith.wildspot-map.jsonp", (tilejson) ->
    map = new google.maps.Map(document.getElementById("map_landing_page"),
      center: new google.maps.LatLng(-12.6, 26)
      disableDefaultUI: true
      zoom: 5
      mapTypeId: google.maps.MapTypeId.ROADMAP
    )
    # map.mapTypes.set "mb", new wax.g.connector(tilejson)
    # map.setMapTypeId "mb"

    cartodb_layer =
      getTileUrl: (coord, zoom) ->
        "http://craigmills.cartodb.com/tiles/sites/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
      tileSize: new google.maps.Size(256, 256)
    
    cartodb_imagemaptype = new google.maps.ImageMapType(cartodb_layer)
    map.overlayMapTypes.insertAt 0, cartodb_imagemaptype

    # cartodb_gmapsv3 = new google.maps.CartoDBLayer(
    #   map_canvas: "map_landing_page"
    #   map: map
    #   user_name: "craigmills"
    #   table_name: "sites"
    #   query: "SELECT cartodb_id,the_geom_webmercator,magnitude FROM {{table_name}}"
    #   tile_style: '#{{table_name}}{marker-fill:#E25B5B}'
    #   map_style: true
    #   infowindow: "SELECT cartodb_id,the_geom_webmercator,magnitude FROM {{table_name}} WHERE cartodb_id={{feature}}"
    #   auto_bound: false
    #   debug: false
    # )
    # 
