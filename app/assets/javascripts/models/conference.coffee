class App.Models.Conference extends Backbone.Model
  toEvent: ->
    _.extend(_.clone(@attributes),
      start: @startMoment(),
      end: @calendarEndMoment()
    )

  startMoment: ->
    moment @get('start')

  endMoment: ->
    moment @get('end')

  calendarEndMoment: ->
    @endMoment().add(1, 'day')

  hasLatLng: ->
    @get('latitude') && @get('longitude')
  

class App.Collections.Conferences extends Backbone.Collection
  model: App.Models.Conference
  url: Routes.conferences_path({ format: 'json' })
    
class App.Collections.FilteredConferences extends Backbone.FilteredCollection
  model: App.Models.Conference

  filterByDates: (start, end) ->
    @setFilter (item) ->
      item.startMoment().isBetween(start, end) ||
        item.endMoment().isBetween(start, end)

