$ ->
  $('#conference-browser').each ->
    conferences = new App.Collections.Conferences(window.conferencesData)
    view = new App.Views.ConferenceBrowser(
      el: this
      conferences: conferences
    ).render()

