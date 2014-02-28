module.exports =

  users:
    resource: "users"
    path: "/users"

  user_search:
    resource: "user_search"
    path: "/users"
    query:
      login:
        required: true
        type: "string"

  user:
    resource: "user"
    template: "/users/:id"

  questions:
    resource: "questions"
    template: "/users/:id/questions"
    query:
      category:
        type: "string"
        enum: ["Entertainment", "Science", "Sports"]

  question:
    resource: "question"
    template: "/questions/:id"

  #statistics:
    #resource: "statistics"
    #template: "/users/:id/statistics"

