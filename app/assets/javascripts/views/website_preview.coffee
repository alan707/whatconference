class App.Views.WebsitePreview extends Backbone.View
  template: '<iframe class="website-preview"></iframe>'

  initialize: (options) ->
    _.extend this, options
    $(window).on "resize", _.throttle(@render, 100)

  render: =>
    url = _.result this, 'urlSource'
    if @$el.is(':visible') && @currentUrl != url
      @initialRender() unless @iframe?

      @iframe.attr('src', url)
      @currentUrl = url

    this

  initialRender: ->
    @$el.html @template
    @iframe = @$('iframe')
