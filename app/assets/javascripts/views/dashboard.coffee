App.Views.Dashboard = Backbone.View.extend
  initialize: (options) ->
    _.extend this, options

    @date ?= moment() # today

    @listenTo @collection, 'sync', @render
    
    @collection.fetch()

  render: ->
    @$el.html JST["templates/conference_list"]({ conferences: @collection })

    this
