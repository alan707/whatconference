class App.Models.Conference extends Backbone.Model
  toEvent: ->
    @attributes

  startMoment: ->
    moment @get('start')

  endMoment: ->
    moment @get('end')

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

