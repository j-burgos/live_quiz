# LiveQuiz.Umbrella

Umbrella project for LiveQuiz that contains:

* `/apps/live_quiz`: Business logic
* `/apps/live_quiz_web`: Web user facing project

## Run application interactive

```
iex -S mix phx.server
```

## Setup database

```
mix ecto.create
mix ecto.migrate
```

## Seed questions and answers

```
mix live_quiz.import_questions <amount>
```

## Run tests

```
mix test
```

## Pre-commit hooks

```
# .githooks/pre-commit

# default elixir formatter
mix format --check-formatted
# package to check refactoring oportunities
mix credo
```

## Code coverage
```
mix coveralls --umbrella
```
