GitHubClient = require("../client")
Testify = require("testify")
assert = require "assert"

helpers = require "./helpers"
client = new GitHubClient(helpers.login, helpers.password)

Testify.test "Resources from templatized urls", (context) ->

  context.test "User", (context) ->
    context.test ".get()", (context) ->
      user = client.resources.user(login: "dyoder")
      user.get
        on:
          response: (response) ->
            context.fail "Unexpected response status: #{response.status}"
          200: (response, user) ->
            context.test "provides a user resource", ->
              assert.equal user.resource_type, "user"

  context.test "Repositories", (context) ->
    context.test ".list()", (context) ->
      user_repos = client.resources.user_repositories(login: "dyoder")
      user_repos.list
        on:
          response: (response) ->
            context.fail "Unexpected response status: #{response.status}"
          200: (response, list) ->
            context.test "provides an array", (context) ->
              assert.equal list.constructor, Array
              context.test "of repository resources", ->
                for item in list
                  assert.equal item.resource_type, "repository"





