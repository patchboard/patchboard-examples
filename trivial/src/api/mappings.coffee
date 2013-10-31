module.exports =

  users:
    resource: "users"
    path: "/users"

  user_search:
    resource: "user"
    path: "/user"
    query:
      login:
        required: true
        type: "string"

  user:
    resource: "user"
    template: "/users/:id"
    associations: ["questions"]

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

