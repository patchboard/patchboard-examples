module.exports =
  users:
    actions:
      create:
        method: "POST"
        request_schema: "user"
        response_schema: "user"
        status: 201
      login:
        method: "GET"
        query:
          login:
            required: true
            type: "string"
        response_schema: "user"
        status: 200

  user:
    actions:
      get:
        method: "GET"
        response_schema: "user"
        status: 200
      delete:
        method: "DELETE"
        status: 204

  questions:
    actions:
      ask:
        method: "POST"
        response_schema: "question"
        status: 201

  statistics:
    actions:
      get:
        method: "GET"
        response_schema: "statistics"
        status: 200

  question:
    actions:
      answer:
        method: "POST"
        request_schema: "answer"
        response_schema: "result"
        status: 200

  global_statistics:
    actions:
      get:
        method: "GET"
        response_schema: "global_statistics"
        status: 200

