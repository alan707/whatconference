$ ->
  whole_usa =
    zoom: 4,
    lat:   38.8722838,
    lng: -457.9752401,

  $("#conference-map").each (index, element) ->
    map = new GMaps(
      _.extend(
        el: '#conference-map',
        whole_usa
      )
    )

    with_lat_lng = (conference) ->
      conference.latitude && conference.longitude

    conference_marker_for = (conference) ->
      lat: conference.latitude,
      lng: conference.longitude,
      title: conference.title,
      animation: 'DROP',
      infoWindow:
        content: "<a href=\"#{conference.url}\">#{conference.title}</a>"

    add_conference_markers = (conferences) ->
      markers = _.map(
        _.filter(conferences, with_lat_lng),
        conference_marker_for
      )
      map.addMarkers markers
        
    $.get Routes.conferences_path({ format: 'json' }), add_conference_markers
