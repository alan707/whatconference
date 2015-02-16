$ ->
  $('#start_date').datepicker format: 'yyyy-mm-dd'
  $('#end_date').datepicker format: 'yyyy-mm-dd'
  $('.dp').on 'change', ->
    $('.datepicker').hide()
    return
