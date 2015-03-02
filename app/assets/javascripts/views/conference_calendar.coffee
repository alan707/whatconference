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
