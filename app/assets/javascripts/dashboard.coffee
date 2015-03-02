$ ->
  $('#dashboard-conference-list').each ->
    conferences = new App.Collections.Conferences
    view = new App.Views.Dashboard(
      el: this
      collection: conferences
    ).render()

