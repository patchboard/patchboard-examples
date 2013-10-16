GitHubClient = require("../client")
Testify = require("testify")
assert = require "assert"

helpers = require "./helpers"
client = new GitHubClient(helpers.login, helpers.password)

Testify.test "Resources provided full URLs by the directory", (context) ->
  repositories = client.resources.repositories

  context.test "the authenticated user", (context) ->
    client.resources.authenticated_user.get
      on:
        response: (response) ->
          context.fail "Unexpected response status: #{response.status}"
        200: (response, user) ->
          context.test "response is a resource", ->
            assert.equal user.resource_type, "user"

  context.test "Own repositories", (context) ->
    repositories.list
      on:
        response: (response) ->
          context.fail "Unexpected response status: #{response.status}"
        200: (response, list) ->
          context.test "response is an array", (context) ->
            assert.equal list.constructor, Array
            context.test "items are all repositories", ->
              for item in list
                assert.equal item.resource_type, "repository"

  context.test "Own orgs", (context) ->
    client.resources.organizations.list
      on:
        response: (response) ->
          context.fail "Unexpected response status: #{response.status}"
        200: (response, list) ->
          context.test "response is an array", (context) ->
            assert.equal list.constructor, Array
            context.test "items are all organizations", ->
              for item in list
                assert.equal item.resource_type, "organization"


