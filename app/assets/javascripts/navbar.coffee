$ ->
  $('nav.navbar').each ->
    new App.Views.Navbar(el: this)
