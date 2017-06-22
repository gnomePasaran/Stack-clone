$ ->
  $(document).on 'ajax:success', '.subscription', (data, status, xhr) ->
    buttons_wrapper = $(this).closest('.subscription_buttons')
    if xhr == 'nocontent'
      buttons_wrapper.removeClass('subscribed')
    else
      buttons_wrapper.addClass('subscribed')
