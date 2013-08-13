path = require "path"

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
        login: login
        email: email
        id: id
        answered: {}
        questions: {id: id}

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


class QuestionCollection

  constructor: (@application, data_file) ->
    @ttl = @application.question_ttl

    question_list = require data_file
    @data = {}
    # the current data files I have contain Arrays of Objects
    for question in question_list
      Object.freeze(question)
      @data[question.id] = question

  create: (user, callback) ->
    answered = user.answered
    available = (id for id in Object.keys(@data) when !answered[id])
    if available.length == 0
      callback null, null
    else
      qid = available[Math.floor(Math.random() * available.length)]
      source_question = @data[qid]
      question =
        user_id: user.id
        expires: Date.now() + @ttl
        question: source_question.question
        id: source_question.id
        a: source_question.a, b: source_question.b,
        c: source_question.c, d: source_question.d
      callback null, question


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

    #@user_logins = {}
    #@user_ids = {}
    #@timed_questions = {}

    #questions = require data_file
    #@questions = {}
    #for question in questions
      #@questions[question.id] = question

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


  #global_statistics: (callback) ->
    #callback {name: "internal server error", message: "unimplemented"}


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
    answer_letter = answer.letter
    # TODO: figure out what should happen when a user is deleted,
    # then tries to answer an unexpired timed_question.
    @questions.find question_id, (error, question) =>
      if error
        callback(error)
      else
        if question.answered == true
          callback {name: "conflict", message: "Question has already been answered"}
        else


    #if question = @timed_questions[question_id]
      #user = @user_ids[question.user_id]
      #if user.answered[question_id]
        #callback {name: "conflict", message: "Question has already been answered"}
      #else
        #user.answered[question_id] = question
        #if Date.now() > question.expire
          #question.success = false
          #callback {name: "forbidden", message: "Answer submitted after question expired"}
        #else
          #correct = @questions[question.id].answer
          #question.success = answer_letter == correct
          #callback null,
            #success: question.success
            #correct: correct
    #else
      #callback {name: "not found"}

  answered_questions: (id, callback) ->
    if user = @user_ids[id]
      callback null, user.answered
    else
      callback {name: "not found"}

  statistics: (id, callback) ->
    if user = @user_ids[id]
    else
      callback {name: "not found"}


  # Helpers

  _generate_id: ->
    "#{@id_base}:#{@counter++}"

  _get_question: (user) ->
    answered = user.answered
    available = (id for id in Object.keys(@questions) when !answered[id])
    if available.length == 0
      null
    else
      qid = available[Math.floor(Math.random() * available.length)]
      source_question = @questions[qid]
      question =
        user_id: user.id
        expires: Date.now() + @question_ttl
        question: source_question.question
        id: source_question.id
        a: source_question.a, b: source_question.b,
        c: source_question.c, d: source_question.d





