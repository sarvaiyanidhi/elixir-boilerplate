defmodule ElixirBoilerplateGraphQL.Plugs.AssignContext do
  @behaviour Plug

  import Plug.Conn

  @authorization_header "authorization"

  def init(opts), do: opts

  def call(conn, _) do
    put_private(conn, :absinthe, %{context: build_context(conn)})
  end

  defp build_context(conn) do
    %{
      foo: :bar
    }
  end
end
