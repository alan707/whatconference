GROWL_STYLE =
  info: 'default'
  notice: 'notice'
  alert: 'error'

GROWL_TITLE =
  info: 'Info'
  notice: 'Notice'
  alert: 'Error'

$ ->
  $(".flash .alert").each ->
    flash = $(this).data('flash')
    $.growl(
      message: $(this).html()
      title: GROWL_TITLE[flash]
      style: GROWL_STYLE[flash]
      duration: 5000
    )
    $(this).remove()

