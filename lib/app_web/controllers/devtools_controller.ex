defmodule AppWeb.DevtoolsController do
  use AppWeb, :controller

  # Return 204 No Content to silence Chrome DevTools probe requests
  def ignore(conn, _params) do
    send_resp(conn, 204, "")
  end
end

