Testify = require "testify"
assert = require "assert"

{discover, saneTimeout} = require "./helpers"

discover (client) ->
  Testify.test "Trivial API", (suite) ->

    suite.test "create a user", (context) ->

      login = new Buffer(Math.random().toString().slice(0, 8)).toString("hex")
      client.resources.users.create {login: login}, (error, {resource}) ->
        context.test "Expected response", ->
          assert.ifError(error)

        context.test "has expected fields", ->
          assert.equal resource.login, login
          assert.ok resource.url
          assert.ok !resource.email
        context.test "has expected actions", ->
          assert.equal resource.questions?.ask?.constructor, Function

        suite.test "asking for a question", (context) ->
          resource.questions.ask (error, {resource}) ->

            context.test "Expected response", ->
              assert.ifError(error)

            context.test "question has expected fields", ->
              assert.ok resource.url
              assert.ok resource.question
              assert.ok "abcd".split("").every (item) ->
                resource[item]

            suite.test "answering the question", (context) ->
              resource.answer {letter: "d"}, (error, response) ->

                context.test "Expected response", ->
                  assert.ifError(error)

                context.test "success", ->
                  result = response.resource
                  assert.equal result.success, true
                  assert.equal result.correct, "d"

                  suite.test "attempting to answer again", (context) ->
                    resource.answer {letter: "d"}, (error, response) ->

                      context.test "receive expected HTTP error", ->
                        assert.ok error
                        assert.equal error.status, 409
                        data = JSON.parse error.response.body
                        assert.equal data.message,
                          "Question has already been answered"

