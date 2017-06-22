update_score = (el, xhr) ->
  votes = $(el).closest('.votes')
  votes.find('.score').text(xhr.responseJSON.score)
  
  if xhr.responseJSON.voted
    votes.addClass 'voted'
  else
    votes.removeClass 'voted'

$ ->
  $(document).on 'ajax:success', '.voting', (e, data, status, xhr) ->
    update_score(this, xhr)
