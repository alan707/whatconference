class App.Views.ConferenceBrowser extends Backbone.View
  initialize: (options) ->
    _.extend this, options

    @filteredConferences = new App.Collections.FilteredConferences(null,
      collection: @conferences
    )

    @calendarConferences = new App.Collections.FilteredConferences(null,
      collection: @conferences
    )

    @list = new App.Views.ConferenceList
      conferences: @filteredConferences

    @calendar = new App.Views.ConferenceCalendar
      conferences: @calendarConferences

    @map = new App.Views.ConferenceMap
      conferences: @filteredConferences

    @listenTo @calendar, 'change:dates', @filterByDates
    @listenTo @map, 'change:bounds', @filterByBounds
    @listenTo @list, 'click:marker', @markerClick

  render: ->
    @$el.append @calendar.el

    @calendar.render()
    # manipulate the calendar DOM to insert the list and map next to the calendar
    @calendar.insert_other_views @list.el, @map.el

    @list.render()
    @map.render()

    this

  filterByDates: (start, end, intervalStart, intervalEnd) ->
    @filteredConferences.filterByDates(intervalStart, intervalEnd)
    @calendarConferences.filterByDates(start, end)

  filterByBounds: (bounds) ->
    @filteredConferences.filterByBounds(bounds)
    @calendarConferences.filterByBounds(bounds)

  markerClick: (index) ->
    @map.popupMarker index

