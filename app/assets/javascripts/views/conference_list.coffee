class App.Views.ConferenceList extends Backbone.View
  template: JST["templates/conference_list"]
  itemTemplate: JST["templates/conference_list_item"]
  emptyTemplate: JST["templates/conference_list_empty"]

  initialize: (options) ->
    _.extend this, options

    @listenTo @conferences, 'reset filter-complete', @render

  render: ->
    marker_index = 0
    if @conferences.isEmpty()
      items = @emptyTemplate()
    else
      items = @conferences.map (conference) =>
        data = conference.attributes
        if conference.hasLatLng()
          _.extend(data, index: marker_index)
          marker_index += 1

        @itemTemplate(data)
      items = items.join("")

    @$el.html @template({ items })
    this

