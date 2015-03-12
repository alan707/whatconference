$ ->
  $('.comment-edit').on 'click', ->
    comment =
      id: $(this).data('comment-id')
      body: $(this).closest('.comments_wrapper').find('.comment-body').html()
    
    template = JST['templates/edit_comment']
    modal = $(template(comment))
    $('body').append(modal)
    # populate the CSRF token in the modal
    $.rails.refreshCSRFTokens()
    modal.modal()
