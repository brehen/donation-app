# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :donation,
  ecto_repos: [Donation.Repo]

# Configures the endpoint
config :donation, DonationWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1IFEDOM70gxiSRvFlUz/V1+TOlC3ipKsalg6Bpg4wuNYYtnCDhH0wCMaBwfEhDNT",
  render_errors: [view: DonationWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Donation.PubSub,
  live_view: [signing_salt: "hwJNNVbA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :donation, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: DonationWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: DonationWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }

config :donation, Donation.Guardian,
       issuer: "donation",
       secret_key: "dUNnKIAgp3HRXp4QPn3tzwlafdNWWns8e33zJYb0Q5+RxyWrqjiPTSJrxYphEU3A"

# config :donation, :phoenix_swagger,
#   swagger_files: %{
#     "booking-api.json" => [router: MyApp.BookingRouter],
#     "reports-api.json" => [router: MyApp.ReportsRouter],
#     "admin-api.json" => [router: MyApp.AdminRouter]
#   }

# Use Jason for JSON parsing in Phoenix
# config :phoenix, :json_library, Jason
config :phoenix_swagger, json_library: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
