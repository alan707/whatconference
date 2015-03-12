class App.Views.ConferenceCalendar extends Backbone.View
  events:
    'click .fc-month-name': 'switchToMonth'

  initialize: (options) ->
    _.extend this, options

    @listenTo @conferences, 'reset filter-complete', @eventsForCalendar

  render: ->
    @$el.fullCalendar
      header:
        left: 'prev,next today'
        center: 'title'
        right: 'year,month'
      defaultView: 'year'
      events: @eventSource
      eventLimit: true
      viewRender: @calendarRendered
      contentHeight: 500
      eventLimit: true # Show more... instead of growing calendar
    this

  calendarView: ->
    @$el.fullCalendar 'getView'

  eventSource: (start, end, timezone, callback) =>
    # get objects from collection and render
    callback @conferences.invoke('toEvent')
  
  calendarRendered: (calendar_view) =>
    cv = @calendarView()
    @trigger 'change:dates', cv.start, cv.end, cv.intervalStart, cv.intervalEnd

  switchToMonth: (event) ->
    date = $(event.target).data('date')
    @$el.fullCalendar 'changeView', 'month'
    @$el.fullCalendar 'gotoDate', date

  insert_other_views: (list_el, map_el) ->
    calendar_el = @$('.fc-view-container').detach()

    @$el.append $('<div class="row"><div class="col-md-6 col-list col-map"></div><div class="col-md-6 col-calendar"></div></div>')

    @$(".col-map").append map_el
    @$(".col-list").append list_el
    @$(".col-calendar").append calendar_el
