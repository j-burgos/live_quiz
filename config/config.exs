# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :live_quiz,
  ecto_repos: [LiveQuiz.Repo]

config :live_quiz_web,
  ecto_repos: [LiveQuiz.Repo],
  generators: [context_app: :live_quiz]

# Configures the endpoint
config :live_quiz_web, LiveQuizWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oVaLkBMGiN122TNYZAhRmnC1AOw2nDgzVSZJkYGRzWzWEdcUKsY6QKJnaUY2OyEe",
  render_errors: [view: LiveQuizWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LiveQuizWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian
config :live_quiz_web, LiveQuizWeb.Guardian,
  issuer: "live_quiz_web",
  secret_key: "2CVX/FE8T5Rf7GNehJaFdmEMN4WOiMNio7Fy3G6LCZLVEHG32KtFGQeTj9EFM0LV"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
