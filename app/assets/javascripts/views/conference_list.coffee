class App.Views.ConferenceList extends Backbone.View
  template: JST["templates/conference_list_item"]

  initialize: (options) ->
    _.extend this, options

    @listenTo @conferences, 'sync', @render

  render: ->
    items = @conferences.map (conference) =>
      @template(conference.attributes)

    @$el.html items.join("")
    this

