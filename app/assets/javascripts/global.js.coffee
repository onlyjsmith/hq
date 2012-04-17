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
  
