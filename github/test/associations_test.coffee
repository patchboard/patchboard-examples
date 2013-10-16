Testify = require("testify")
assert = require "assert"

GitHubClient = require("../client")

helpers = require "./helpers"
client = new GitHubClient(helpers.login, helpers.password)

Testify.test "Resource associations", (context) ->

  #context.test "user repositories", (context) ->
    #user = client.resources.user(login: "dyoder")
    #user.repositories.list
      #on:
        #request_error: (error) ->
          #context.fail(error)
        #response: (response) ->
          #context.fail "unexpected response status: #{response.status}"
        #200: (response, list) ->
          #context.test "result is a non-empty array", ->
            #assert.equal list.constructor, Array
            #assert.ok list.length > 0
          #context.test "each item is a Repository resource", ->
            #for item in list
              #assert.equal item.resource_type, "repository"


  context.test "repository associations", (context) ->
    repo = client.resources.repository(login: "automatthew", name: "fate")

    context.test "post request chaining", (context) ->
      repo.get
        on:
          request_error: (error) -> context.fail(error)
          response: (response) ->
            context.fail "unexpected response status: #{response.status}"
          200: (response, repo) ->
            context.test "creating the association", ->
              contributors = repo.contributors
              context.test "using the association", (context) ->
                repo.contributors.list
                  on:
                    request_error: (error) -> context.fail(error)
                    response: (response) ->
                      context.fail "unexpected response status: #{response.status}"
                    200: (response, contributors) ->
                      context.test "result is a non-empty array", ->
                        assert.equal contributors.constructor, Array
                        assert.ok contributors.length > 0
                      context.test "each item is a User resource", ->
                        for item in contributors
                          assert.equal item.resource_type, "user"

    #context.test "requestless chaining", (context) ->
      #context.test "repository.contributors", (context) ->
        #repo.contributors.list
          #on:
            #request_error: (error) -> context.fail(error)
            #response: (response) ->
              #context.fail "unexpected response status: #{response.status}"
            #200: (response, contributors) ->
              #context.test "result is a non-empty array", ->
                #assert.equal contributors.constructor, Array
                #assert.ok contributors.length > 0
              #context.test "each item is a User resource", ->
                #for item in contributors
                  #assert.equal item.resource_type, "user"

      #context.test "repository.languages", (context) ->
        #repo.languages.list
          #on:
            #request_error: (error) -> context.fail(error)
            #response: (response) ->
              #context.fail "unexpected response status: #{response.status}"
            #200: (response, languages) ->
              #context.test "result is an dictionary containing numbers", ->
                #assert.equal languages.constructor, Object
                #for name, lines of languages
                  #assert.equal name.constructor, String
                  #assert.equal lines.constructor, Number


