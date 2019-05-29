defmodule ElixirBoilerplateWeb.Router do
  use Phoenix.Router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :graphql do
    plug(:accepts, ["json"])

    plug(ElixirBoilerplateGraphQL.Plugs.AssignContext)
  end

  pipeline :browser do
    plug(:accepts, ["html", "json"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:put_layout, {ElixirBoilerplateWeb.Layouts.View, :app})
  end

  scope "/", ElixirBoilerplateWeb do
    pipe_through(:browser)

    get("/", Home.Controller, :index, as: :home)
  end

  # GraphQL
  scope "/graphql" do
    pipe_through(:graphql)

    forward(
      "/",
      Absinthe.Plug,
      json_codec: Jason,
      schema: ElixirBoilerplateGraphQL.Schema,
      socket: ElixirBoilerplateWeb.Socket
    )
  end

  # Development tools
  if Mix.env() == :dev do
    # GraphiQL
    scope "/graphiql" do
      pipe_through(:graphql)

      forward(
        "/",
        Absinthe.Plug.GraphiQL,
        interface: :playground,
        json_codec: Jason,
        schema: ElixirBoilerplateGraphQL.Schema,
        socket: ElixirBoilerplateWeb.Socket
      )
    end
  end
end
