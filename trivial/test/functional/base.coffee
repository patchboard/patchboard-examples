Testify = require "testify"
assert = require "assert"

{discover, saneTimeout} = require "./helpers"

discover (client) ->
  Testify.test "Trivial API", (context) ->
    context.test "create a user", (context) ->
      login = new Buffer(Math.random().toString().slice(0, 8)).toString("hex")
      client.resources.users.create
        content: {login: login}
        on:
          response: (response) ->
            context.fail "Unexpected response status: #{response.status}"
          201: (response, user) ->
            context.test "has expected fields", ->
              assert.equal user.login, login
              assert.ok user.url
              assert.ok !user.email
            context.test "has expected actions", ->
              assert.equal user.questions?.ask?.constructor, Function

            context.test "asking for a question", (context) ->
              user.questions.ask
                on:
                  response: (response) ->
                    context.fail "Unexpected response status: #{response.status}"
                  201: (response, question) ->

                    context.test "question has expected fields", ->
                      assert.ok question.url
                      assert.ok question.question
                      assert.ok "abcd".split("").every (item) ->
                        question[item]

                    context.test "answering the question", (context) ->
                      question.answer
                        content:
                          letter: "d"
                        on:
                          response: (response) ->
                            context.fail "Unexpected response status: #{response.status}"
                          200: (response, result) ->

                            context.test "success", ->
                              assert.equal result.success, true
                              assert.equal result.correct, "d"

                            context.test "attempting to answer again", (context) ->
                              question.answer
                                content:
                                  letter: "d"
                                on:
                                  response: (response) ->
                                    context.test "receive expected HTTP error", ->
                                      assert.equal response.status, 409
                                      assert.equal response.body.data.message,
                                        "Question has already been answered"

