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

    this

  defaultCoordinates:
    zoom: 4,
    lat:   38.8722838,
    lng: -457.9752401,


  addConferenceMarkers: (conferences) ->
    if @map
      @map.removeMarkers()
      markers = @conferences.chain().
        filter(@withLatLng).map(@conferenceMarkerFor).value()

      @map.addMarkers markers
      @map.fitLatLngBounds _.map(markers, @markerToLatLng)

  withLatLng: (conference) =>
    conference.hasLatLng()

  conferenceMarkerFor: (conference, index) =>
    lat: conference.get('latitude'),
    lng: conference.get('longitude'),
    title: conference.get('title'),
    animation: 'DROP',
    icon: google_map_icon_for_index(index)
    infoWindow:
      content: @infoWindowTemplate(conference.attributes)

  markerToLatLng: (marker) ->
    new google.maps.LatLng(marker.lat, marker.lng)
