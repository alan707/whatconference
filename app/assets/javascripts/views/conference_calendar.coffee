class App.Views.ConferenceCalendar extends Backbone.View
  events:
    'click .fc-month-name': 'monthNameClick'

  initialize: (options) ->
    _.extend this, options

    @listenTo @conferences, 'reset filter-complete', @refetchEvents

  # Access the Full Calendar plugin
  calendar: ->
    @$el.fullCalendar.apply @$el, arguments

  render: ->
    @calendar
      header:
        left: 'prev,next today'
        center: 'title'
        right: 'year,month'
      defaultView: 'year'
      events: @eventSource
      eventLimit: true
      viewRender: @calendarRendered
      dayClick: @dayClick
      contentHeight: 500
      eventLimit: true # Show more... instead of growing calendar

    this

  calendarView: ->
    @calendar 'getView'

  eventSource: (start, end, timezone, callback) =>
    # get objects from collection and render
    callback @conferences.invoke('toEvent')

  refetchEvents: ->
    @calendar 'refetchEvents'
  
  calendarRendered: (calendar_view) =>
    cv = @calendarView()
    @trigger 'change:dates', cv.start, cv.end, cv.intervalStart, cv.intervalEnd

  monthNameClick: (event) ->
    date = $(event.target).data('date')
    @switchToMonth date

  dayClick: (date, event, view) =>
    if view.name == 'year'
      @switchToMonth date

  switchToMonth: (date) ->
    @calendar 'changeView', 'month'
    @calendar 'gotoDate', date

  insert_other_views: (list_el, map_el) ->
    calendar_el = @$('.fc-view-container').detach()

    @$el.append $('<div class="row"><div class="col-md-6 col-list col-map"></div><div class="col-md-6 col-calendar"></div></div>')

    @$(".col-map").append map_el
    @$(".col-list").append list_el
    @$(".col-calendar").append calendar_el
