class App.Views.Navbar extends Backbone.View
  elements:
    hideable: '.nav-hideable'
    search_form: '.search-form'
    search_input: '.conference-search'
    search_group: '.search-form .input-group'
    navbar_toggle: '.navbar-toggle'

  events:
    search_input: 'focus'
    search_form: 'blur'

  should_extend: ->
    !@$navbar_toggle.is(':visible')

  search_input_focus: ->
    # Don't extend the search bar on mobile
    if @should_extend()
      extra_width = @$hideable.outerWidth()
      @$hideable.hide()
      @$search_group.animate(width: "#{@$search_group.outerWidth() + extra_width}px", =>
        @wideSearch = true
      )

  search_form_blur: ->
    if @should_extend()
      if @wideSearch
        extra_width = @$hideable.outerWidth()
        @$search_group.delay(400).animate(width: "#{@$search_group.outerWidth() - extra_width}px", =>
          @$hideable.show()
          @$search_group.css width: ''
          @wideSearch = false
        )
      else
        @$search_group.css width: ''

