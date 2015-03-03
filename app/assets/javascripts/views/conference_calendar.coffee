class App.Views.ConferenceCalendar extends Backbone.View
  initialize: (options) ->
    _.extend this, options

    @listenTo @conferences, 'reset filter-complete', @eventsForCalendar

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

  calendarView: ->
    @cv ?= @$el.fullCalendar 'getView'

  eventSource: (start, end, timezone, callback) =>
    @calendarCallback = callback
    @trigger 'change:dates', start, end,
        @calendarView().intervalStart, @calendarView().intervalEnd
  
  eventsForCalendar: ->
    if @calendarCallback
      # get objects from collection and render
      events = @conferences.invoke('toEvent')
      @calendarCallback events

  calendarRendered: (calendar_view) =>
    #@trigger 'change:dates', calendar_view.start, calendar_view.end

  insert_other_views: (list_el, map_el) ->
    calendar_el = @$('.fc-view-container').detach()

    @$el.append $('<div class="row"><div class="col-md-6 col-list col-map"></div><div class="col-md-6 col-calendar"></div></div>')

    @$(".col-list").append list_el
    @$(".col-calendar").append calendar_el
    @$(".col-map").append map_el
