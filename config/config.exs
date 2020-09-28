# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :lknvball,
  ecto_repos: [Lknvball.Repo]

# Configures the endpoint
config :lknvball, LknvballWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "taboNreuZlfRkyc2wJ2hDjVp1455WedTDdO5iziJ0iglDOm7NM55V0Vs4sokGR0z",
  render_errors: [view: LknvballWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Lknvball.PubSub,
  live_view: [signing_salt: "LFzSDAuJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Ueberauth config
config :ueberauth, Ueberauth,
  providers: [
    facebook:
      {Ueberauth.Strategy.Facebook,
       [
         display: "popup"
       ]}
  ]

config :lknvball, LknvballWeb.Guardian,
  issuer: "lknvball",
  secret_key: "8rGJlduQbjek/Vz7ZFAHz2vURwFp5dr16qoh+uV/sYVEmoPi2ugerfuoeZQ5x6tJ"

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_APP_ID"),
  client_secret: System.get_env("FACEBOOK_APP_SECRET")

config :stripity_stripe, api_key: fn -> System.get_env("STRIPE_SECRET") end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
