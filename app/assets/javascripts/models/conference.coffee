App.Models.Conference = Backbone.Model.extend()
  

App.Collections.Conferences = Backbone.Collection.extend
  model: App.Models.Conference
  url: Routes.conferences_path({ format: 'json' })
    

