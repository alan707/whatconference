class App.Models.Conference extends Backbone.Model
  toEvent: ->
    @attributes

  has_lat_lng: ->
    @get('latitude') && @get('longitude')
  

class App.Collections.Conferences extends Backbone.Collection
  model: App.Models.Conference
  url: Routes.conferences_path({ format: 'json' })
    

