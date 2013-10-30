urn = (name) ->
  "urn:patchboard.trivial##{name}"

module.exports =
  users:
    actions:
      create:
        method: "POST"
        request_schema: urn "user"
        response_schema: urn "user"
        status: 201
      login:
        method: "GET"
        query:
          login:
            required: true
            type: "string"
        response_schema: urn "user"
        status: 200

  user:
    actions:
      get:
        method: "GET"
        response_schema: urn "user"
        status: 200
      delete:
        method: "DELETE"
        status: 204

  questions:
    actions:
      ask:
        method: "POST"
        response_schema: urn "question"
        status: 201

  question:
    actions:
      answer:
        method: "POST"
        request_schema: urn "answer"
        response_schema: urn "result"
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

