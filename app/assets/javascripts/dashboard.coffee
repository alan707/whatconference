$ ->
  $('#conference-browser').each ->
    conferences = new App.Collections.Conferences
    view = new App.Views.ConferenceBrowser
      el: this
      conferences: conferences

