defmodule AppWeb.APIController do
  use AppWeb, :controller

  def ask(conn, %{"question" => q}) do
    json(conn, %{answer: "(stub) Thanks for your question about: " <> q, citations: [], chips: []})
  end
end

