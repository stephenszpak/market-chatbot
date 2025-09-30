import Config

config :app, AppWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: String.duplicate("a", 64),
  watchers: [],
  live_reload: [
    patterns: [
      ~r"priv/static/ab_widget/.*(js|css)$",
      ~r"lib/app_web/controllers/.*(ex)$",
      ~r"lib/app_web/controllers/.*/.*(heex|eex)$",
      ~r"lib/app_web/.*(heex|eex)$"
    ]
  ]

config :logger, level: :debug
