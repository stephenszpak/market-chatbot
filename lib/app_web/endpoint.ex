defmodule AppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :app

  # Serve at "/ab_widget/*" and other static files under priv/static
  plug Plug.Static,
    at: "/",
    from: :app,
    gzip: false,
    only: ~w(ab_widget)

  if Application.compile_env(:app, AppWeb.Endpoint)[:code_reloader] do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.MethodOverride
  plug Plug.Head

  plug AppWeb.Router
end
