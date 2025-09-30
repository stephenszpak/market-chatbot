defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AppWeb do
    pipe_through :api
    post "/ask", APIController, :ask
  end

  scope "/", AppWeb do
    pipe_through :browser
    get "/demo", DemoController, :index
    # Swallow Chrome DevTools well-known probe to avoid noisy logs
    get "/.well-known/appspecific/com.chrome.devtools.json", DevtoolsController, :ignore
  end
end
