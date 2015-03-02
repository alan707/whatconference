class App.Views.ConferenceCalendar extends Backbone.View
  initialize: (options) ->
    _.extend this, options

    @listenTo @conferences, 'sync', @eventsForCalendar

    @$el.fullCalendar
      header:
        left: 'prev,next today'
        center: 'title'
        right: 'month'
      events: @eventSource

  eventSource: (start, end, timezone, callback) =>
    @calendarCallback = callback
    @conferences.fetch()
  
  eventsForCalendar: ->
    if @calendarCallback
      # get objects from collection and render
      events = @conferences.map (conference) ->
        conference.toEvent()
      @calendarCallback events

