class App.Views.ConferenceBrowser extends Backbone.View
  initialize: (options) ->
    _.extend this, options

    @date ?= moment() # today

    @list = new App.Views.ConferenceList
      conferences: @conferences

    @calendar = new App.Views.ConferenceCalendar
      conferences: @conferences

    @map = new App.Views.ConferenceMap
      conferences: @conferences

    @listenTo @calendar, 'change:dates', @fetchMoreConferences

  render: ->
    @$el.append @calendar.el

    @calendar.render()
    # manipulate the calendar DOM to insert the list and map next to the calendar
    @calendar.insert_other_views @list.el, @map.el

    @list.render()
    @map.render()

    this


  fetchMoreConferences: (start, end) ->
    console.log "Dates changed #{start?.format?()} #{end?.format?()}"

