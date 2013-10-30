# Patchboard Example: Trivia Game

An example use of [Patchboard](https://github.com/automatthew/patchboard) to
provide an HTTP REST API.

## The Patchboard API Definition

* [URL mappings](./src/api/mappings.coffee)
* [Resource definitions](./src/api/resources.coffee)
* [Schema definitions](./src/api/schema.coffee)


## The Service

* [Server script](./bin/server.coffee)
* [HTTP request handlers](./src/handlers.coffee)
* [Application](./src/application.coffee)

Patchboard.Server uses the API Definition to construct an HTTP request
dispatcher.  The dispatcher takes a dictionary of handlers, which must
correspond to the resources and actions described in the API. The handler
properties represent the resource names.  The value of each property is
a dictionary of actions for that resource.  The value of each action is
a function which will be used to handle an HTTP request.

The application implementation is intentionally simple, meant only to
demonstrate how Patchboard request dispatching can be glued to a backend.


## Usage

Run the server:

    bin/server.coffee

## Functional test

    coffee test/functional/base.coffee


## APIflow (pseudo synchronous)

``` coffee
{resources} = Client.discover(url)

user = resources.users.create(params)
user = resources.users.login(params)

question = user.questions.ask()
result = question.answer("b")

# can't answer twice
409_conflict = question.answer("c")
```


## Acknowledgments

Trivia questions came from the "misterhouse" home automation project. I deserve a medal for extracting them from the data format they came in.  Not a very important medal, but something shiny.

https://github.com/hollie/misterhouse

https://github.com/hollie/misterhouse/tree/master/data/trivia

