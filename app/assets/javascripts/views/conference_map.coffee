class App.Views.ConferenceMap extends Backbone.View
  className: 'map-container'
  template: '<div class="map">'
  infoWindowTemplate: JST["templates/conference_info_window"]

  initialize: (options) ->
    _.extend this, options

    @listenTo @conferences, 'reset filter-complete', @addConferenceMarkers

  render: ->
    @$el.html @template
    @map = new GMaps(
      _.extend(
        el: @$('.map')[0],
        @defaultCoordinates
      )
    )

    @addConferenceMarkers()

    this

  minZoomOffset: 0.5 # offset to lat/lng bounds when there is only 1 marker

  defaultCoordinates:
    zoom: 4,
    lat:   38.8722838,
    lng: -457.9752401,


  addConferenceMarkers: ->
    if @map
      @map.removeMarkers()
      markers = @conferences.chain().
        filter(@withLatLng).map(@conferenceMarkerFor).value()

      unless _.isEmpty(markers)
        @map.addMarkers markers
        @map.fitLatLngBounds @latLngForBounds(markers)
        if @map.zoom < @minZoom
          @map.setZoom @minZoom

  withLatLng: (conference) =>
    conference.hasLatLng()

  conferenceMarkerFor: (conference, index) =>
    lat: conference.get('latitude'),
    lng: conference.get('longitude'),
    title: conference.get('title'),
    animation: 'DROP',
    icon: googleMapIconForIndex(index)
    infoWindow:
      content: @infoWindowTemplate(conference.attributes)

  latLngForBounds: (markers) ->
    latLng = _.map(markers, @markerToLatLng)
    if latLng.length == 1
      m = markers[0]
      # append two more coordinates to prevent zooming in too close with only one marker
      latLng.push new google.maps.LatLng(m.lat + @minZoomOffset, m.lng + @minZoomOffset)
      latLng.push new google.maps.LatLng(m.lat - @minZoomOffset, m.lng - @minZoomOffset)
    latLng

  markerToLatLng: (marker) ->
    new google.maps.LatLng(marker.lat, marker.lng)
