class App.Views.Navbar extends Backbone.View
  elements:
    hideable: '.nav-hideable'
    search_form: '.search-form'
    search_input: '.conference-search'
    search_group: '.search-form .input-group'

  events:
    search_input: 'focus'
    search_form: 'blur'

  search_input_focus: ->
    extra_width = @$hideable.outerWidth()
    @$hideable.hide()
    @$search_group.animate(width: "#{@$search_group.outerWidth() + extra_width}px", =>
      @wideSearch = true
    )

  search_form_blur: ->
    if @wideSearch
      extra_width = @$hideable.outerWidth()
      @$search_group.delay(400).animate(width: "#{@$search_group.outerWidth() - extra_width}px", =>
        @$hideable.show()
        @$search_group.css width: "auto"
        @wideSearch = false
      )
    else
      @$search_group.css width: "auto"

