App.comments = App.cable.subscriptions.create "CommentsChannel",
  question: -> $('[data-question-channel]')

  connected: ->
    # Called when the subscription is ready for use on the server
    setTimeout =>
      @followCurrentPage()
      @installPageChangeCallback()
    , 1000
    
  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    comments = $('#' + data.commentable + '_' + data.commentable_id + '_comments')
    comments.append(data.comment)

  followCurrentPage: ->
    if questionId = @question().data('question-channel')
      @perform 'follow', commentable_id: questionId
    else
      @perform 'unfollow'

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'turbolinks:load', -> App.comments.followCurrentPage()
