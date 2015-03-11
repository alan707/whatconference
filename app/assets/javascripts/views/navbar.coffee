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
    @$search_group.css 'width', "#{@$search_group.outerWidth() + extra_width}px"

  search_form_blur: ->
    @$hideable.show()
    @$search_group.css 'width', "auto"

