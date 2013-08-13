#!/usr/bin/env coffee

Patchboard = require "patchboard"
api = require "./api"
Application = require "./application"

[interpreter, script, data_file] = process.argv

application = new Application
  data_file: data_file

handlers = require("./handlers")(application)

server = new Patchboard.Server api,
  host: "127.0.0.1"
  port: 1979
  url: "http://127.0.0.1:1979/"
  handlers: handlers
  decorator: ({context}) =>
    context.decorate (schema, data) =>
      if schema.properties?.url? && data.id
        data.url = context.url(schema.name, data.id)


server.run()

