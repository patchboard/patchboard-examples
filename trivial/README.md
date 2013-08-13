
---

Trivia questions came from the "misterhouse" home automation project. I deserve a medal for extracting them from the data format they came in.  Not a very important medal, but something shiny.

https://github.com/hollie/misterhouse
https://github.com/hollie/misterhouse/tree/master/data/trivia


## APIflow (pseudo synchronous)

directory = client.discover()

user = directory.users.create(params)
user = directory.users.login(params)

question = user.questions.ask()

result = question.answer("b")
409_conflict = question.answer("c")

stats = user.statistics
answered = user.answered()

user = directory.users.login(params)


## Possible improvements

questions need timestamps, and some kind of persistence in the service.

different question media types: multiple-choice vs no answers


