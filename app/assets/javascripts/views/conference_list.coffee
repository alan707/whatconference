class App.Views.ConferenceList extends Backbone.View
  template: JST["templates/conference_list"]
  itemTemplate: JST["templates/conference_list_item"]

  initialize: (options) ->
    _.extend this, options

    @listenTo @conferences, 'sync', @render

  render: ->
    marker_index = 0
    items = @conferences.map (conference) =>
      data = conference.attributes
      if conference.has_lat_lng()
        _.extend(data, index: marker_index)
        marker_index += 1

      @itemTemplate(data)

    @$el.html @template(items: items.join(""))
    this

