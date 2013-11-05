type = (name) ->
  "application/vnd.trivial.#{name}+json;version=1.0"

module.exports =
  users:
    actions:
      create:
        method: "POST"
        request:
          type: type "user"
        response:
          type: type "user"
          status: 201

  user_search:
    actions:
      get:
        method: "GET"
        response:
          type: type "user"
          status: 200

  user:
    actions:
      get:
        method: "GET"
        response:
          type: type "user"
          status: 200
      delete:
        method: "DELETE"
        response:
          status: 204

  questions:
    actions:
      ask:
        method: "POST"
        response:
          type: type "question"
          status: 201

  question:
    actions:
      answer:
        method: "POST"
        request:
          type: type "answer"
        response:
          type: type "result"
          status: 200

  #statistics:
    #actions:
      #get:
        #method: "GET"
        #response_schema: urn "statistics"
        #status: 200

  #global_statistics:
    #actions:
      #get:
        #method: "GET"
        #response_schema: urn "global_statistics"
        #status: 200

