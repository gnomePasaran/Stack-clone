@App ||= {}
App.utils =
  errorsHandler: (selector, errors) ->
    all_errors = ''

    for index of errors
      all_errors += JST["templates/shared/errors"]({
        error: errors[index]
      })

    selector.html(all_errors)
