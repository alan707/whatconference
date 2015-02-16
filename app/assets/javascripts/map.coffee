$ ->
  $("#conference-map").each (index, element) ->
    map = new GMaps({
      el: '#conference-map',
      zoom: 4,
      lat:   38.8722838,
      lng: -457.9752401,
    })

    add_conference_marker = (conference) ->
      if conference.latitude && conference.longitude
        map.addMarker {
          lat: conference.latitude,
          lng: conference.longitude,
          title: conference.title,
          infoWindow: {
            content: "<a href=\"#{conference.url}\">#{conference.title}</a>"
          }
        }

    add_conference_markers = (conferences) ->
      $.each conferences, (index, conference) ->
        add_conference_marker conference
        
    $.get Routes.conferences_path({ format: 'json' }), add_conference_markers
