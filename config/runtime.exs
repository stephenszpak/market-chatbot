import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise "DATABASE_URL is missing. Example: ecto://USER:PASS@HOST/DATABASE"

  config :app, App.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE", "10"))

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "SECRET_KEY_BASE is missing. Generate one with: mix phx.gen.secret"

  port = String.to_integer(System.get_env("PORT", "4000"))

  config :app, AppWeb.Endpoint,
    http: [ip: {0, 0, 0, 0}, port: port],
    url: [host: System.get_env("PHX_HOST", "example.com"), port: port],
    secret_key_base: secret_key_base,
    server: true
end
