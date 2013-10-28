Testify = require "testify"
assert = require "assert"

{discover, saneTimeout} = require "./helpers"

discover (client) ->
  Testify.test "Trivial API", (context) ->
    context.test "create a user", (context) ->

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

        context.test "asking for a question", (context) ->
          resource.questions.ask (error, {resource}) ->

            context.test "Expected response", ->
              assert.ifError(error)

            context.test "question has expected fields", ->
              assert.ok resource.url
              assert.ok resource.question
              assert.ok "abcd".split("").every (item) ->
                resource[item]

            context.test "answering the question", (context) ->
              resource.answer {letter: "d"}, (error, response) ->

                context.test "Expected response", ->
                  assert.ifError(error)

                context.test "success", ->
                  result = response.resource
                  assert.equal result.success, true
                  assert.equal result.correct, "d"

                #context.test "attempting to answer again", (context) ->
                  #question.answer
                    #content:
                      #letter: "d"
                    #on:
                      #response: (response) ->
                        #context.test "receive expected HTTP error", ->
                          #assert.equal response.status, 409
                          #assert.equal response.body.data.message,
                            #"Question has already been answered"

