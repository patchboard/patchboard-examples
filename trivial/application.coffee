path = require "path"

module.exports = class Application

  constructor: (@options={}) ->
    @question_ttl = @options.question_ttl || 10 * 1000 # ms.

    if @options.data_file
      # TODO: make this work when passed an absolute path for data_file
      data_file = path.join process.cwd(), @options.data_file
    else
      data_file = "./data/Mixed.json"

    # silly + overkill given that this app is necessarily single process.
    @id_base = [process.pid, Math.floor(Date.now() / 1000)].join(":")
    @counter = 0

    @users = new UserCollection(@)
    @questions = new QuestionCollection(@, data_file)

  # global actions
  create_user: (params, callback) ->
    @users.create(params, callback)

  login: ({login}, callback) ->
    @users.find {login: login}, (error, user) =>
      if error
        if error.name == "not found"
          callback {name: "unauthorized"}
        else
          callback {name: "internal server error", message: error.message}
      else
        callback null, user


  # user specific actions
  get_user: (id, callback) ->
    @users.find({id: id}, callback)

  delete_user: (id, callback) ->
    @users.delete({id: id}, callback)

  ask: (user_id, callback) ->
    @users.find {id: user_id}, (error, user) =>
      if error
        callback(error)
      else
        @questions.create(user, callback)

  answer_question: (question_id, answer, callback) ->
    # TODO: figure out what should happen when a user is deleted,
    # then tries to answer an unexpired timed_question.
    @questions.find question_id, (error, question) =>
      if error
        callback(error)
      else
        if question.answered == true
          callback {name: "conflict", message: "Question has already been answered"}
        else if Date.now() > question.expires
          question.success = false
          callback {name: "forbidden", message: "Answer submitted after question expired"}
        else
          question.answered = true
          question.success = (answer.letter == question.answer)
          callback null,
            success: question.success
            correct: question.answer


  user_asked: (id, callback) ->
    @users.asked id, callback

  #statistics: (id, callback) ->
    #if user = @user_ids[id]
    #else
      #callback {name: "not found"}


  # Helpers

  _generate_id: ->
    "#{@id_base}:#{@counter++}"




class UserCollection

  constructor: (@application) ->
    @ids = {}
    @logins = {}

  find: ({id, login}, callback) ->
    if id && user = @ids[id]
      callback null, user
    else if login && user = @logins[login]
      callback null, user
    else
      callback
        name: "not found"

  create: (params, callback) ->
    {login, email} = params
    if @logins[login]
      callback
        name: "conflict"
        message: "User with this login already exists"
    else
      id = @application._generate_id()
      user =
        type: "user"
        login: login
        email: email
        id: id
        asked: {}
        questions: {id: id, type: "questions"}

      @logins[user.login] = user
      @ids[user.id] = user
      callback null, user

  delete: (params, callback) ->
    @find params, (error, user) =>
      if error
        callback error
      else
        delete @ids[user.id]
        delete @logins[user.login]
        callback null

  asked: (id) ->
    if user = @ids[id]
      user.asked
    else
      callback
        name: "not found"


class QuestionCollection

  constructor: (@application, data_file) ->
    @ttl = @application.question_ttl
    question_list = require data_file

    @source_questions = {}
    @ids = []
    @user_questions = {}
    # the current data files I have contain Arrays of Objects
    for question in question_list
      Object.freeze(question)
      @source_questions[question.id] = question
      @ids.push question.id

  create: (user, callback) ->
    asked = user.asked
    available = (id for id in @ids when !asked[id])
    if available.length == 0
      callback null, null
    else
      qid = available[Math.floor(Math.random() * available.length)]
      source_question = @source_questions[qid]
      question =
        type: "question"
        id: "#{user.id}.#{source_question.id}"
        source_id: source_question.id
        user_id: user.id
        expires: Date.now() + @ttl
        question: source_question.question
        a: source_question.a, b: source_question.b,
        c: source_question.c, d: source_question.d

      user.asked[question.id] = @user_questions[question.id] =
        expires: question.expires
        answer: source_question.answer

      callback null, question

  find: (id, callback) ->
    if question = @user_questions[id]
      callback null, question
    else
      callback new Error "No question for id: '#{id}'"

