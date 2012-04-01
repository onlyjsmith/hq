$ ->
  capitaliseFirstLetter = (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)
  
  $.widget "custom.catcomplete", $.ui.autocomplete,
    _renderMenu: (ul, items) ->
      self = this
      currentCategory = ""
      $.each items, (index, item) ->
        unless item.category is currentCategory
          ul.append "<li class='ui-autocomplete-category'>" + capitaliseFirstLetter(item.category) + "</li>"
          currentCategory = item.category
        self._renderItem ul, item
  


# // window.VALIDATION = {
# //   map: null,
# //   mapOptions: {
# //     center: new google.maps.LatLng(-18.521283, 36.650391),
# //     zoom: 4,
# //     mapTypeId: google.maps.MapTypeId.SATELLITE,
# //     mapTypeControl: false,
# //     panControl: false,
# //     zoomControl: false,
# //     rotateControl: false,
# //     streetViewControl: false,
# //     overviewMapControl: true,
# //     overviewMapControlOptions: {
# //       opened: true
# //     }
# //   },
# //   mapPolygon: null,
# //   mapPolygonOptions: {
# //     editable: true
# //   },
# //   minEditZoom: 10,
# //   mangroves: null,
# //   mangroves_params: null,
# //   mangroves_validated: null,
# //   mangroves_validated_params: null,
# //   corals: null,
# //   corals_params: null,
# //   corals_validated: null,
# //   corals_validated_params: null,
# //   currentAction: null,
# //   submitModalEvents: {},
# //   selectedLayer: 0
# // };
