$ ->
  $(document).on 'click', '.open-comment-form', (e) ->
    e.preventDefault()
    comments = $(this).closest('.comments')
    comments.find('.comment-form').show()
    comments.find('.open-comment-form').hide()

  $(document).on 'ajax:success', '.new_comment', (e, data, status, xhr) ->
    comments = $(this).closest('.comments')
    comments.find('.comment_errors').text('')
    comments.find('.comment-form textarea').val('')
    comments.find('.comment-form').hide()
    comments.find('.open-comment-form').show()
  .on 'ajax:error', '.new_comment', (e, xhr) ->
    selector = $(this).closest('.comment-form').find('.comment_errors')
    App.utils.errorsHandler(selector, xhr.responseJSON.errors)
