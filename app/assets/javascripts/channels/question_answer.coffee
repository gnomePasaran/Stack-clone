App.question_answer = App.cable.subscriptions.create "QuestionAnswerChannel",
  question: -> $('[data-question-channel]')

  connected: ->
    setTimeout =>
      @followCurrentPage()
      @installPageChangeCallback()
    , 1000

  disconnected: ->

  received: (data) ->
    $('.answers').append(JST['templates/answers/show'](data.answer))

  followCurrentPage: ->
    if questionId = @question().data('question-channel')
      @perform 'follow', question_id: questionId
    else
      @perform 'unfollow'

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'turbolinks:load', -> App.question_answer.followCurrentPage()
