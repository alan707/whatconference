class App.Views.ConferenceCalendar extends Backbone.View
  initialize: (options) ->
    _.extend this, options

    @listenTo @conferences, 'sync', @eventsForCalendar

  render: ->
    @$el.fullCalendar
      header:
        left: 'prev,next today'
        center: 'title'
        right: 'month'
      events: @eventSource
      viewRender: @calendarRendered
      contentHeight: 500
      eventLimit: true # Show more... instead of growing calendar

    this

  eventSource: (start, end, timezone, callback) =>
    @calendarCallback = callback
    @conferences.fetch()
  
  eventsForCalendar: ->
    if @calendarCallback
      # get objects from collection and render
      events = @conferences.map (conference) ->
        conference.toEvent()
      @calendarCallback events

  calendarRendered: (calendar_view) =>
    @trigger 'change:dates', calendar_view.start, calendar_view.end

  insert_other_views: (list_el, map_el) ->
    calendar_el = @$('.fc-view-container').detach()

    @$el.append $('<div class="row"><div class="col-md-6 col-list"></div><div class="col-md-6 col-calendar col-map"></div></div>')

    @$(".col-list").append list_el
    @$(".col-calendar").append calendar_el
    @$(".col-map").append map_el
