defmodule AppWeb.DemoController do
  use AppWeb, :controller

  def index(conn, _params) do
    html = """
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset=\"utf-8\" />
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />
        <title>AB Insights Assistant Demo</title>
        <link rel=\"stylesheet\" href=\"/ab_widget/styles.css\" />
      </head>
      <body>
        <div id=\"ab-insights-root\"></div>
        <script src=\"/ab_widget/main.js\"></script>
        <script>
          window.ABInsightsAssistant && window.ABInsightsAssistant.mount('#ab-insights-root');
        </script>
      </body>
    </html>
    """

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, html)
  end
end
