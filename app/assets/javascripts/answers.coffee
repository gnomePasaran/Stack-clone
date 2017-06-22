$ ->
  $(document).on 'click', '.answer-edit-form-trigger', (e) ->
    e.preventDefault()
    $(this).hide()
    $(this).closest('.answer').find('.answer_form_wrapper').show()

  $(document).on 'ajax:success', '.new_answer, .edit_answer',
  (e, data, status, xhr) ->
    form_wrapper = $(this).closest('.answer_form_wrapper')
    form_wrapper.find('.answer_errors').text('')

    if $(this).hasClass('edit_answer')
      form_wrapper.hide()
      answer = $(this).closest('.answer')
      answer.find('.answer-edit-form-trigger').show()
      answer.find('.body').html(xhr.responseJSON.body)
    else
      form_wrapper.find('textarea').val('')

  .on 'ajax:error', '.new_answer, .edit_answer', (e, xhr) ->
    selector = $(this).closest('.answer_form_wrapper').find('.answer_errors')
    App.utils.errorsHandler(selector, xhr.responseJSON.errors)

  $(document).on 'ajax:success', '.delete-answer', ->
    $(this).closest('.answer').remove()
