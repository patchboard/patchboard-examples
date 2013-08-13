Testify = require "testify"
assert = require "assert"

Application = require "../../application"
application = new Application
  question_ttl: 100

Testify.test "Trivial Application", (context) ->


  context.test "creating a user", (context) ->
    application.create_user {login: "matthew"}, (error, user) ->
      context.test "result has expected properties", ->
        assert.equal user.login, "matthew"
        assert.equal user.answered?.constructor, Object

      context.test "attempting to create user with existing login", (context) ->
        application.create_user {login: "matthew"}, (error, user) ->
          context.test "receive expected error", ->
            assert.ok error
            assert.equal error.name, "conflict"


        context.test "asking a question", (context) ->

          application.create_timed_question user.id, (error, question) ->

            context.test "expected properties", ->
              assert.ok !question.answer

            context.test "answering the question correctly", (context) ->
              # What a cheater.
              correct_answer = application.questions[question.id].answer
              application.answer_question question.id, correct_answer, (error, result) ->
                context.test "receive successful result", ->
                  assert.equal result.success, true
                  assert.ok result.correct

            context.test "attempting to answer again", (context) ->
              application.answer_question question.id, "a", (error, result) ->
                context.test "receive correct error", ->
                  assert.ok error
                  assert.equal error.name, "conflict"

        context.test "answering a question after expiry", (context) ->
          application.create_timed_question user.id, (error, question) ->
            fn = ->
              application.answer_question question.id, question.answer, (error, result) ->
                context.test "receive correct error", ->
                  assert.ok error
                  assert.equal error.name, "forbidden"
            setTimeout fn, 120



