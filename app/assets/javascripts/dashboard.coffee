$ ->
  $('#conference-browser').each ->
    conferences = new App.Collections.Conferences
    view = new App.Views.ConferenceBrowser(
      el: this
      conferences: conferences
    ).render()
    # Load initial conferences
    conferences.fetch(reset: true)

