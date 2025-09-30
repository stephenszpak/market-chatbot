defmodule AppWeb.ErrorHTML do
  use Phoenix.HTML

  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end

