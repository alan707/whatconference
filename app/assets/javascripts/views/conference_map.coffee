class App.Views.ConferenceMap extends Backbone.View
  infoWindowTemplate: JST["templates/conference_info_window"]

  initialize: (options) ->
    _.extend this, options

    @listenTo @conferences, 'sync', @add_conference_markers

    @map = new GMaps(
      _.extend(
        el: @el,
        @default_coordinates
      )
    )

  default_coordinates:
    zoom: 4,
    lat:   38.8722838,
    lng: -457.9752401,


  add_conference_markers: (conferences) ->
    markers = @conferences.chain().
      filter(@with_lat_lng).map(@conference_marker_for).value()

    @map.addMarkers markers
    @map.fitLatLngBounds _.map(markers, @marker_to_lat_ln)

  with_lat_lng: (conference) =>
    conference.has_lat_lng()

  conference_marker_for: (conference) =>
    lat: conference.get('latitude'),
    lng: conference.get('longitude'),
    title: conference.get('title'),
    animation: 'DROP',
    infoWindow:
      content: @infoWindowTemplate(conference.attributes)

  marker_to_lat_ln: (marker) ->
    new google.maps.LatLng(marker.lat, marker.lng)
