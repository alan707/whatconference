$ ->
  # TODO: Refactor this spaghetti into a Backbone View
  $('.daterange').daterangepicker()

  $('.location').each ->
    element = this
    # Prevent submitting the form when pressing enter on the auto-complete field
    $(element).on 'keypress', (event)->
      false if event.which == 13
      
    autocomplete = new google.maps.places.Autocomplete element

    google.maps.event.addListener autocomplete, 'place_changed', ->
      place = autocomplete.getPlace()

      if place.geometry
        save_latitude_longitude place.geometry.location

      save_city_state place.address_components

  save_latitude_longitude = (location) ->
    $('#conference_latitude').val location.lat()
    $('#conference_longitude').val location.lng()

  save_city_state = (components) ->
    address = {}
    for component in components
      if _.contains(component.types, "locality")
        address.city = component.long_name
      else if _.contains(component.types, "administrative_area_level_1")
        address.state = component.short_name
      else if _.contains(component.types, "country")
        address.country = component.long_name

    city_state = [address.city || '', address.state || address.country || ''].join(", ")
    $("#conference_city_state").val city_state

  $('#comment_body').on 'keypress', (event) ->
    enterKey = 13
    if event.which == enterKey && event.shiftKey && !event.metaKey && !event.ctrlKey && !event.altKey
      $(this).closest('form').submit()
      event.preventDefault()
    null

  $('.btn-radar').on 'click', ->
    $(this).toggleClass 'following'
 
  $('.simple-conference-map').each ->
    simple_map = new App.Views.SimpleConferenceMap(el: this)
    simple_map.render()
      
