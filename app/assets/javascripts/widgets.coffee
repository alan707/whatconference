$ ->
  # Focus state for Flat-UI append/prepend inputs
  $('.input-group').on('focus', '.form-control', ->
    $(this).closest('.input-group, .form-group').addClass 'focus'
  ).on 'blur', '.form-control', ->
    $(this).closest('.input-group, .form-group').removeClass 'focus'

