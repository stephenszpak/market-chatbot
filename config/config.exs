import Config

config :app, ecto_repos: [App.Repo]

config :app, AppWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [formats: [html: AppWeb.ErrorHTML, json: AppWeb.ErrorJSON], layout: false],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "ABIAssistant"],
  http: [port: 4000]

config :phoenix, :json_library, Jason

if config_env() == :dev do
  import_config "dev.exs"
end
