$ ->
  $(document).on 'click', '.question-edit-form-trigger', (e) ->
    e.preventDefault()
    $(this).hide()
    $('.question_form_wrapper').show()

  $(document).on 'ajax:success', '.question_form_wrapper .edit_question', (data, status, xhr) ->
    $('.question-edit-form-trigger').show()
    $('.question_form_wrapper').hide()
