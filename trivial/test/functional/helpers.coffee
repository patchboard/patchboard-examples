Client = require("patchboard-js")

exports.saneTimeout = (ms, fn) -> setTimeout(fn, ms)

exports.discover = (callback) ->

  Client.discover "http://localhost:1979/", (error, client) ->
    if error
      throw error
    else
      callback client


