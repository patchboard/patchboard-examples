module.exports = (application) ->

  default_handler = (context) ->
    {match: {resource_type, action_name, path}, request: {body, query}} = context
    options =
      content: body
      query: query
      identifier: path
    application[resource_type][action_name](options, response_callback)

  response_callback = (context) ->
    {match} = context
    resource_type = match.resource_type
    status = match.success_status || 200
    (error, result) ->
      if error
        context.error error.name, error.message
      else
        context.respond status, result

  users:
    create: (context) ->
      application.create_user context.request.body, response_callback(context)
    login: (context) ->
      application.login context.request.query, response_callback(context)

  user:
    get: (context) ->
      application.get_user context.match.path.id, response_callback(context)
    delete: (context) ->
      application.delete_user context.match.path.id, response_callback(context)

  questions:
    ask: (context) ->
      user_id = context.match.path.id
      application.ask user_id, (error, result) ->
        if error
          context.error error.name, error.message
        else
          if result
            context.respond 201, result
          else
            # There are no more questions to ask.
            url = context.url "statistics", user_id
            context.respond 303, {url: url}
              "Location": url
              "Content-Type": "application/json"


  statistics:
    get: (context) ->
      id = context.match.path.id
      application.statistics id, response_callback(context)

  question:
    answer: (context) ->
      id = context.match.path.id
      answer = context.request.body
      application.answer_question id, answer, response_callback(context)

  statistics:
    get: (context) ->
      application.global_statistics response_callback(context)


