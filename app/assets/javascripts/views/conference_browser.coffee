class App.Views.ConferenceBrowser extends Backbone.View
  initialize: (options) ->
    _.extend this, options

    @filteredConferences = new App.Collections.FilteredConferences(null,
      collection: @conferences
    )

    @list = new App.Views.ConferenceList
      conferences: @filteredConferences

    @calendar = new App.Views.ConferenceCalendar
      conferences: @filteredConferences

    @map = new App.Views.ConferenceMap
      conferences: @filteredConferences

    @listenTo @calendar, 'change:dates', @filterByDates

  render: ->
    @$el.append @calendar.el

    @calendar.render()
    # manipulate the calendar DOM to insert the list and map next to the calendar
    @calendar.insert_other_views @list.el, @map.el

    @list.render()
    @map.render()

    this

  filterByDates: (start, end) =>
    @filteredConferences.filterByDates(start, end)

