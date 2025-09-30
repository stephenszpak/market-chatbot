defmodule AppWeb.ErrorJSON do
  def render("404.json", _assigns), do: %{error: "Not Found"}
  def render("500.json", _assigns), do: %{error: "Internal Server Error"}
  def render(_template, _assigns), do: %{error: "Error"}
end

