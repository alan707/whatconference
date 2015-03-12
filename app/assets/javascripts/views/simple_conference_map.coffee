class App.Views.SimpleConferenceMap extends Backbone.View
  template: JST["templates/conference_map"]

  initialize: (options) ->
    _.extend this, options
    @conference ?= new App.Models.Conference(@attributesFromDOM())

    @listenTo @conference, 'change', @addMarker

  attributesFromDOM: ->
    latitude: @$el.data('latitude')
    longitude: @$el.data('longitude')

  render: ->
    @$el.html @template
    @map = new GMaps(
      _.extend(
        el: @$('.map')[0],
        @defaultCoordinates
      )
    )

    @addMarker()

    this

  minZoomOffset: 0.5 # offset to lat/lng bounds when there is only 1 marker

  defaultCoordinates:
    zoom: 4,
    lat:   38.8722838,
    lng: -457.9752401,

  addMarker: ->
    if @map
      @map.removeMarkers()
      if @conference.hasLatLng()
        marker = @conferenceMarker()
        @map.addMarker marker
        @map.fitLatLngBounds @boundsFor(marker)

  conferenceMarker: ->
    lat: @conference.get('latitude'),
    lng: @conference.get('longitude'),
    icon: googleMapIconForIndex(-1)

  boundsFor: (marker) ->
    latLng = [new google.maps.LatLng(marker.lat, marker.lng)]

    # append two more coordinates to prevent zooming in too close with only one marker
    latLng.push new google.maps.LatLng(marker.lat + @minZoomOffset, marker.lng + @minZoomOffset)
    latLng.push new google.maps.LatLng(marker.lat - @minZoomOffset, marker.lng - @minZoomOffset)

    latLng

