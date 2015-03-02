class App.Views.ConferenceBrowser extends Backbone.View
  initialize: (options) ->
    _.extend this, options

    @date ?= moment() # today

    @list = new App.Views.ConferenceList
      el: @$("#conference-list")[0]
      conferences: @conferences

    @calendar = new App.Views.ConferenceCalendar
      el: @$("#conference-browser-calendar")[0]
      conferences: @conferences

    @map = new App.Views.ConferenceMap
      el: @$("#conference-browser-map")[0]
      conferences: @conferences

    @listenTo @calendar, 'change:dates', @fetchMoreConferences

  render: ->
    @list.render()
    @calendar.render()
    @map.render()
    this


  fetchMoreConferences: (start, end) ->
    console.log "Dates changed #{start?.format?()} #{end?.format?()}"

